require 'thor/group'
require 'active_support/inflector'

module Grapethor
  class Endpoint < Thor::Group
    include Thor::Actions
    include Grapethor::Utils

    attr_reader :api_version,
                :app_path,
                :end_resource,
                :end_name,
                :end_method,
                :end_desc,
                :end_params,
                :end_query,
                :end_query_with_params,
                :request_path,
                :end_query_sample,
                :request_path_sample

    namespace :endpoint

    def self.exit_on_failure?
      true
    end

    def self.source_root
      File.join(__dir__, '..')
    end


    argument :resource, type: :string,
                        desc: "Resource name"

    argument :name,     type: :string,
                        desc: 'Endpoint name',
                        default: ""


    class_option :path,    aliases: '-p',
                           type: :string,
                           default: '.',
                           desc: 'Relative path to application directory'

    class_option :version, aliases: '-v',
                           type: :string,
                           default: 'v1',
                           desc: 'API version tag'

    class_option :method,  aliases: '-m',
                           type: :string,
                           default: 'GET',
                           enum: %w[GET POST PUT DELETE],
                           desc: 'HTTP request method'

    class_option :desc,    aliases: '-d',
                           type: :string,
                           default: "",
                           desc: 'Endpoint description'

    class_option :params,  aliases: '-a',
                           type: :hash,
                           default: {},
                           desc: 'Request resource (path) param'

    class_option :query,   aliases: '-q',
                           type: :hash,
                           default: {},
                           desc: 'Request query params'


    def parse_args_and_opts
      @end_resource          = resource.downcase.singularize
      @end_name              = name.downcase.singularize
      @end_method            = options[:method].upcase
      @end_params            = options[:params]
      @end_query             = options[:query].map { |k, v| [k, v.downcase] }.to_h
      @end_query_with_params = options[:params].merge(options[:query]).map { |k, v| [k, v.downcase] }.to_h
      @api_version           = options[:version].downcase
      @app_path              = options[:path]
    end


    def prepare_endpoint
      prepare_request_path

      prepare_request_path_sample

      @end_desc = options[:desc].empty? ? "#{end_method} #{request_path}" : options[:desc]
    end


    def validate_target_api
      unless api_version_exists?
        alert "API version '#{api_version}' does not exist!"
        exit
      end
    end


    def create_endpoint
      report("Creating new endpoint...") do
        unless File.exist?("#{app_path}/api/#{api_version}/#{end_resource_plural}.rb")
          directory "templates/endpoint/api/\%api_version\%", "#{app_path}/api/#{api_version}"
        end

        insert_into_file "#{app_path}/api/#{api_version}/#{end_resource_plural}.rb",
                         end_content,
                         after: "resource :#{end_resource.pluralize} do\n"

        insert_into_file "#{app_path}/api/#{api_version}/base.rb",
                         "\s\s\s\smount API#{api_version}::#{end_resource.classify.pluralize}\n",
                         before: "\s\s\s\s# mount API#{api_version}::<ResourceOrEndpointClass>\n"

        unless File.exist?("#{app_path}/#{test_dirname}/api/#{api_version}/#{end_resource_plural}_#{test_dirname}.rb")
          directory "templates/endpoint_#{app_test_framework}", app_path
        end

        insert_into_file "#{app_path}/#{test_dirname}/api/#{api_version}/#{end_resource_plural}_#{test_dirname}.rb",
                         end_test_content,
                         after: "\s\s### grapethor works here ###\n"
      end
    end


    private

    def prepare_request_path
      req_path = []
      end_params.each { |k, v| req_path << ":#{k}" } unless end_params.empty?
      req_path << "#{end_name}" unless end_name.empty?
      @request_path = req_path.join('/')
    end


    def prepare_request_path_sample
      req_path_sample = []
      end_params.each { |k,v| req_path_sample << sample_value(v, true) } unless end_params.empty?
      req_path_sample << "#{end_name}" unless end_name.empty?
      @request_path_sample = req_path_sample.join('/')
    end


    def api_version_exists?
      Dir.exist?("#{app_path}/api/#{api_version}")
    end


    def end_content
      erb_file = File.join(__dir__, "../templates/endpoint.rb.erb")
      erb_templates = File.read(erb_file)
      ERB.new(erb_templates, nil, '-').result(binding)
    end


    def end_test_content
      erb_file = File.join(__dir__, "../templates/endpoint_#{app_test_framework}.rb.erb")
      erb_templates = File.read(erb_file)
      ERB.new(erb_templates, nil, '-').result(binding)
    end


    def end_resource_plural
      end_resource.pluralize
    end
  end
end
