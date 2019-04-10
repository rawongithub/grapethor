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


  it 'prevents executing endpoint command for non-existent api version' do
    out = File.read("#{@test_dir}/outputs/endpoint_err.out")
    cmd = capture_subprocess_io do
      system "#{@grapethor_exe} endpoint #{@endpoint_resource} -v nonexistent"
    end.join('')

    assert_equal out, cmd
  end


  it 'executes "endpoint" command within application root directory' do
    out = File.read("#{@test_dir}/outputs/endpoint.out")
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ api #{@api_version} ]
      end
    end
    cmd = capture_subprocess_io do
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ endpoint #{@endpoint_resource} #{@endpoint_name} -v #{@api_version} ]
      end
    end.join('')

    assert_equal out, cmd
  end


  it 'creates endpoint' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
      Dir.chdir(@app_name) do
        ::Grapethor::CLI.start %W[ api #{@api_version} ]
        ::Grapethor::CLI.start %W[ endpoint #{@endpoint_resource} #{@endpoint_name} -v #{@api_version} ]
      end
    end

    assert true
  end
end
