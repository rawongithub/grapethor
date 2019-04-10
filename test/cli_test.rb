require "test_helper"
require "active_support/core_ext/string/filters"

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


  describe 'version' do
    it 'has a version number' do
      refute_nil ::Grapethor::VERSION
    end

    it 'executes "version" command' do
      out = File.read("#{@test_dir}/outputs/version.out")
      cmd = capture_subprocess_io do
        ::Grapethor::CLI.start %w[ version ]
      end.join('')

      assert_equal out, cmd
    end
  end


  describe 'help' do
    it 'executes "help" command' do
      out = File.read("#{@test_dir}/outputs/help.out")
      cmd = capture_subprocess_io do
        ::Grapethor::CLI.start %w[ help ]
      end.join('')

      out_truncated = out.split("\n").map!{|s| s.truncate(80, omission: '...')}
      cmd_truncated = cmd.split("\n").map!{|s| s.truncate(80, omission: '...')}

      assert_equal out_truncated, cmd_truncated
    end


    it 'executes "help new" command' do
      out = File.read("#{@test_dir}/outputs/help_new.out")
      cmd = capture_subprocess_io do
        ::Grapethor::CLI.start %w[ help new ]
      end.join('')

      assert_equal out, cmd
    end


    it 'executes "help api" command' do
      out = File.read("#{@test_dir}/outputs/help_api.out")
      cmd = capture_subprocess_io do
        ::Grapethor::CLI.start %w[ help api ]
      end.join('')

      assert_equal out, cmd
    end


    it 'executes "help endpoint" command' do
      out = File.read("#{@test_dir}/outputs/help_endpoint.out")
      cmd = capture_subprocess_io do
        ::Grapethor::CLI.start %w[ help endpoint ]
      end.join('')

      assert_equal out, cmd
    end

    it 'executes "help resource" command' do
      out = File.read("#{@test_dir}/outputs/help_resource.out")
      cmd = capture_subprocess_io do
        ::Grapethor::CLI.start %w[ help resource ]
      end.join('')

      assert_equal out, cmd
    end
  end
end
