require 'bigdecimal'

module Grapethor
  module Utils

    VALID_QUERY_PARAMS = {
      boolean: {
        type: 'Boolean',
        sample: true
      },
      date: {
        type: 'Date',
        sample: "'<%= Date.today %>'"
      },
      datetime: {
        type: 'DateTime',
        sample: "'<%= DateTime.now %>'"
      },
      decimal: {
        type: 'BigDecimal',
        sample: BigDecimal(123.45, 2)
      },
      float: {
        type: 'Float',
        sample: 123.45
      },
      integer: {
        type: 'Integer',
        sample: 123
      },
      string: {
        type: 'String',
        sample: "'MyString'"
      },
      time: {
        type: 'Time',
        sample: "'<%= Time.now %>'"
      }
    }

    TEST_FRAMEWORK_DIRNAME = {
      minitest: 'test',
      rspec: 'spec'
    }


    private

    def alert(msg, color='red')
      say "\n#{msg}\n\n", color.to_sym
    end


    def report(msg)
      arguments = self.class.arguments.inject({}) { |args, a| args.merge!(a.name => instance_eval(a.name)) }
      say <<~MSG

        #{msg}
        arguments: #{arguments}
        options: #{options}

      MSG
      yield
      say "\nWell done!"
    end


    def param_to_type(param)
      VALID_QUERY_PARAMS.dig(param.to_sym, :type) || 'Unknown'
    end


    def sample_value(param, path=false)
      val = VALID_QUERY_PARAMS.dig(param.to_sym, :sample)
      if path && val.respond_to?(:tr!)
        val.tr!("'", "")
      end
      val || 'unknown'
    end


    def app_test_framework
      return 'minitest' if File.read('Gemfile').include? "gem 'minitest'"
      return 'rspec'    if File.read('Gemfile').include? "gem 'rspec'"
    end


    def test_dirname
      TEST_FRAMEWORK_DIRNAME[app_test_framework.to_sym]
    end

  end
end
