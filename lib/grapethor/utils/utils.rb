require 'bigdecimal'

module Grapethor
  module Utils

    CONFIG_FILENAME = '.grapethor.yml'

    ATTRS_MAP = {
      activerecord: {
        bigint: {
          type: 'Integer',
          sample: 123456789
        },
        # binary: {
        #   type: '',
        #   sample:
        # },
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
        numeric: {
          type: 'Numeric',
          sample: 123
        },
        string: {
          type: 'String',
          sample: "'MyString'"
        },
        text: {
          type: 'String',
          sample: "'MyText'"
        },
        time: {
          type: 'Time',
          sample: "'<%= Time.now %>'"
        }
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
      ATTRS_MAP.dig(app_orm.to_sym, param.to_sym, :type) || 'Unknown'
    end


    def sample_value(param, path=false)
      val = ATTRS_MAP.dig(app_orm.to_sym, param.to_sym, :sample)
      if path && val.respond_to?(:tr!)
        val.tr!("'", "")
      end
      val || 'unknown'
    end


    def app_test_framework
      YAML.load(File.read(CONFIG_FILENAME))['app_test_framework']
    end


    def test_dirname
      TEST_FRAMEWORK_DIRNAME[app_test_framework.to_sym]
    end


    def app_orm
      YAML.load(File.read(CONFIG_FILENAME))['app_orm']
    end
  end
end
