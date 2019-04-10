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


  it 'executes "new" command' do
    out = File.read("#{@test_dir}/outputs/new.out")
    cmd = capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
    end.join('')

    assert_equal out, cmd
  end


  it 'creates new application' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} ]
    end

    assert File.directory?("#{@app_name}")

    assert File.exist?("#{@app_name}/.gitignore")
    assert File.exist?("#{@app_name}/Gemfile")
    assert File.exist?("#{@app_name}/README.md")
    assert File.exist?("#{@app_name}/Rakefile")
    assert File.exist?("#{@app_name}/api/base.rb")
    assert File.exist?("#{@app_name}/app/exceptions/not_found_error.rb")
    assert File.exist?("#{@app_name}/bin/console")
    assert File.exist?("#{@app_name}/bin/server")
    assert File.exist?("#{@app_name}/bin/setup")
    assert File.exist?("#{@app_name}/config.ru")
    assert File.exist?("#{@app_name}/config/application.rb")
    assert File.exist?("#{@app_name}/config/boot.rb")
    assert File.exist?("#{@app_name}/config/environment.rb")
    assert File.exist?("#{@app_name}/db/seeds.rb")
    assert File.exist?("#{@app_name}/lib/tasks/routes.rake")
    assert File.exist?("#{@app_name}/lib/tasks/test.rake")
    assert File.exist?("#{@app_name}/config/database.yml")

    assert File.executable?("#{@app_name}/bin/console")
    assert File.executable?("#{@app_name}/bin/setup")
    assert File.executable?("#{@app_name}/bin/server")
  end


  it '--test=minitest generates minitest stuff' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} -t minitest]
    end

    assert File.exist?("#{@app_name}/test/support/reporters.rb")
    assert File.exist?("#{@app_name}/test/support/test_case.rb")
    assert File.exist?("#{@app_name}/test/test_helper.rb")
  end


  it '--test=rspec generates rspec stuff' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} -t rspec ]
    end

    assert File.exist?("#{@app_name}/spec/spec_helper.rb")
  end


  it '--docker option generates docker stuff' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} --docker ]
    end

    assert File.exist?("#{@app_name}/Dockerfile")
    assert File.exist?("#{@app_name}/docker-compose.yml")
  end


  it '--no-docker option skips docker stuff' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} --no-docker ]
    end

    refute File.exist?("#{@app_name}/Dockerfile")
    refute File.exist?("#{@app_name}/docker-compose.yml")
  end


  it '--swagger option generates swagger docs' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} --swagger ]
    end

    assert Dir.exist?("#{@app_name}/swagger-ui")
  end


  it '--no-swagger option skips swagger docs' do
    capture_subprocess_io do
      ::Grapethor::CLI.start %W[ new #{@app_name} --no-swagger ]
    end

    refute Dir.exist?("#{@app_name}/swagger-ui")
  end

end
