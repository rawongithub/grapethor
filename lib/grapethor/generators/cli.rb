require 'thor'

module Grapethor
  class CLI < Thor
    include Thor::Actions
    include Grapethor::Utils

    check_unknown_options!

    def self.exit_on_failure?
      true
    end


    desc 'version', 'Displays Grapethor version'
    map %w[-v --version] => :version
    def version
      say "Grapethor #{VERSION}"
    end


    # register(class_name, subcommand_alias, usage_list_string, description_string, options={})
    register(Grapethor::New, 'new', 'new NAME', 'Creates new Grape application', options)
    commands['new'].options = Grapethor::New.class_options

    register(Grapethor::Api, 'api', 'api VERSION', 'Creates new API within application', options)
    commands['api'].options = Grapethor::Api.class_options

    register(Grapethor::Endpoint, 'endpoint', 'endpoint RESOURCE [NAME]', 'Creates new Endpoint within API', options)
    commands['endpoint'].options = Grapethor::Endpoint.class_options

    register(Grapethor::Resource, 'resource', 'resource NAME', 'Creates new Resource within API', options)
    commands['resource'].options = Grapethor::Resource.class_options
  end
end
