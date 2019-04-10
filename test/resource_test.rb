describe Grapethor do

  before do
    $PROGRAM_NAME = 'grapethor'
    @app_name = 'TestApp'
    @api_version = 'test1'
    @endpoint_resource = 'item'
    @endpoint_name = 'search'
    @resource_name = 'thing'
    @grapethor_exe = File.expand_path("../exe/grapethor", __dir__)
    @test_dir = File.expand_path(__dir__)
    @temp_dir = Dir.mktmpdir
    Dir.chdir(@temp_dir)
  end

  after do
    Dir.chdir('/')
    FileUtils.remove_entry(@temp_dir)
  end


  it 'prevents executing resource command for non-existent api version' do
    out = File.read("#{@test_dir}/outputs/resource_err.out")
    cmd = capture_subprocess_io do
      system "#{@grapethor_exe} resource #{@resource_name} -v nonexistent"
    end.join('')

    assert_equal out, cmd
  end


  it 'executes "resource" command within application root directory' do
    out = File.read("#{@test_dir}/outputs/resource.out")
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ api #{@api_version} ]
      end
    end
    cmd = capture_subprocess_io do
      Dir.chdir(@app_name) do
        fake_time = Time.new(2019, 03, 24, 22, 18, 01)
        Time.stub :now, fake_time do
          ::Grapethor::CLI.start %W[ resource #{@resource_name} -v #{@api_version} ]
        end

      end
    end.join('')

    assert_equal out, cmd
  end


  it 'creates resource' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ api #{@api_version} ]
        ::Grapethor::CLI.start %W[ resource #{@resource_name} -v #{@api_version} ]
      end
    end

    assert true
  end
end
