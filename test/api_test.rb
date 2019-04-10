require "test_helper"

describe Grapethor::New do

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


  it 'prevents executing api command outside application root directory' do
    out = File.read("#{@test_dir}/outputs/api_err.out")
    cmd = capture_subprocess_io do
      system "#{@grapethor_exe} api #{@api_version}"
    end.join('')

    assert_equal out, cmd
  end


  it 'executes "api" command within application root directory' do
    out = File.read("#{@test_dir}/outputs/api.out")
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
    end
    cmd = capture_subprocess_io do
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ api #{@api_version} ]
      end
    end.join('')

    assert_equal out, cmd
  end


  it 'creates api' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ api #{@api_version} ]
      end
    end

    assert File.exist?("#{@app_name}/api/#{@api_version}/base.rb")
    assert File.exist?("#{@app_name}/test/support/api_#{@api_version}_test_case.rb")
    assert File.exist?("#{@app_name}/api/base.rb")
  end
end
