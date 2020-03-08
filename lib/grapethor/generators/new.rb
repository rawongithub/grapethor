require 'thor/group'

module Grapethor
  class New < Thor::Group
    include Thor::Actions
    include Grapethor::Utils

    attr_reader :app_name,
                :app_path,
                :app_prefix,
                :app_server,
                :app_test_framework,
                :app_db,
                :app_orm,
                :app_license,
                :app_copyright,
                :app_ruby


    namespace :new

    def self.exit_on_failure?
      true
    end


    def self.source_root
      File.join(__dir__, '..')
    end


    argument :name, type: :string,
                    desc: 'Application name'


    class_option :path,      aliases: '-p',
                             type: :string,
                             default: '.',
                             desc: 'Relative path to place application directory'

    class_option :prefix,    aliases: '-x',
                             type: :string,
                             default: 'api',
                             desc: 'Add Application URL prefix'

    class_option :db,        aliases: '-d',
                             type: :string,
                             default: 'sqlite',
                             enum: %w[sqlite postgresql mysql],
                             desc: 'Use specific database'

    class_option :orm,       aliases: '-o',
                             type: :string,
                             default: 'activerecord',
                             enum: %w[activerecord],
                             desc: 'Use specific ORM'

    class_option :server,    aliases: '-s',
                             type: :string,
                             default: 'thin',
                             enum: %w[thin puma],
                             desc: 'Preconfigure web server'

    class_option :test,      aliases: '-t',
                             type: :string,
                             default: 'minitest',
                             enum: %w[minitest rspec],
                             desc: 'Use specific test framework'

    class_option :docker,    type: :boolean,
                             default: true,
                             desc: 'Use docker'

    class_option :license,   aliases: '-l',
                             type: :string,
                             default: 'mit',
                             enum: %w[mit apache2 freebsd newbsd gpl2 gpl3 mpl2 cddl1 epl1],
                             desc: 'Add software license information'

    class_option :copyright, aliases: '-c',
                             type: :string,
                             desc: 'Add copyright information within license file'

    class_option :ruby,      aliases: '-r',
                             type: :string,
                             default: "#{RUBY_VERSION}",
                             desc: 'Ruby version for application'

    class_option :swagger,   type: :boolean,
                             default: true,
                             desc: 'Generate swagger documentation and install swagger-ui'


    def parse_args_and_opts
      @app_name           = name
      @app_path           = options[:path]
      @app_prefix         = options[:prefix]
      @app_server         = options[:server]
      @app_test_framework = options[:test]
      @app_db             = options[:db]
      @app_orm            = options[:orm]
      @app_docker         = options[:docker]
      @app_license        = options[:license]
      @app_copyright      = options[:copyright] || "Author of #{app_name}"
      @app_ruby           = options[:ruby]
      @app_swagger        = options[:swagger]
    end


    def create_new
      report("Creating new application...") do
        directory 'templates/new', File.join(app_path, app_name)
        chmod File.join(app_path, app_name, 'bin', 'console'), 0755
        chmod File.join(app_path, app_name, 'bin', 'setup'), 0755
        chmod File.join(app_path, app_name, 'bin', 'server'), 0755

        directory "templates/#{app_db}", "#{app_path}/#{app_name}"

        directory "templates/#{app_test_framework}", "#{app_path}/#{app_name}"

        directory "templates/docker", "#{app_path}/#{app_name}" if app_docker?

        directory "templates/license/#{app_license}", "#{app_path}/#{app_name}"

        directory "templates/swagger", "#{app_path}/#{app_name}" if app_swagger?
      end
    end


    private

    def app_docker?
      @app_docker
    end


    def app_swagger?
      @app_swagger
    end


    def rspec?
      @app_test_framework == 'rspec'
    end


    def app_license_link
      {
        mit:     '[MIT License](http://opensource.org/licenses/MIT)',
        apache2: '[Apache-2.0 License](https://opensource.org/licenses/Apache-2.0)',
        freebsd: '[FreeBSD License](https://opensource.org/licenses/BSD-2-Clause)',
        newbsd:  '[New BSD License](https://opensource.org/licenses/BSD-3-Clause)',
        gpl2:    '[GPL-3.0 License](https://opensource.org/licenses/GPL-2.0)',
        gpl3:    '[GPL-2.0 License](https://opensource.org/licenses/GPL-3.0)',
        mpl2:    '[MPL-2.0 License](https://opensource.org/licenses/MPL-2.0)',
        cddl1:   '[CDDL-1.0 License](https://opensource.org/licenses/CDDL-1.0)',
        epl1:    '[EPL-1.0 License](https://opensource.org/licenses/EPL-1.0)'
      }[app_license.to_sym]
    end
  end
end
