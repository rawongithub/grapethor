require "test_helper"

describe Grapethor::Utils do


  before do
    @generator = Grapethor::CLI.new
    @stub_orm = 'activerecord'
  end

  it '#alert' do
    msg = 'sample alert'
    out = "\n#{msg}\n\n"
    assert_output(out) do
      @generator.send(:alert, msg)
    end
  end


  it '#param_to_type' do
    @generator.stub :app_orm, @stub_orm do
      assert_equal 'Integer',    @generator.send(:param_to_type, :bigint)
      assert_equal 'Boolean',    @generator.send(:param_to_type, :boolean)
      assert_equal 'Date',       @generator.send(:param_to_type, :date)
      assert_equal 'DateTime',   @generator.send(:param_to_type, :datetime)
      assert_equal 'BigDecimal', @generator.send(:param_to_type, :decimal)
      assert_equal 'Float',      @generator.send(:param_to_type, :float)
      assert_equal 'Integer',    @generator.send(:param_to_type, :integer)
      assert_equal 'Numeric',    @generator.send(:param_to_type, :numeric)
      assert_equal 'String',     @generator.send(:param_to_type, :string)
      assert_equal 'String',     @generator.send(:param_to_type, :text)
      assert_equal 'Time',       @generator.send(:param_to_type, :time)
      assert_equal 'Unknown',    @generator.send(:param_to_type, :something)
    end
  end


  it '#sample_value' do
    @generator.stub :app_orm, @stub_orm do
      assert_equal 123456789,             @generator.send(:sample_value, :bigint)
      assert_equal true,                  @generator.send(:sample_value, :boolean)
      assert_instance_of Date,            @generator.send(:sample_value, :date)
      assert_instance_of DateTime,        @generator.send(:sample_value, :datetime)
      assert_equal BigDecimal(123.45, 2), @generator.send(:sample_value, :decimal)
      assert_equal 123.45,                @generator.send(:sample_value, :float)
      assert_equal 123,                   @generator.send(:sample_value, :integer)
      assert_equal 123,                   @generator.send(:sample_value, :numeric)
      assert_equal 'MyString',            @generator.send(:sample_value, :string)
      assert_equal 'MyText',              @generator.send(:sample_value, :text)
      assert_instance_of Time,            @generator.send(:sample_value, :time)
      assert_equal 'unknown',             @generator.send(:sample_value, :something)
    end
  end


  it '#sample_value for path' do
    @generator.stub :app_orm, @stub_orm do
      assert_equal 123456789,             @generator.send(:sample_value, :bigint, true)
      assert_equal true,                  @generator.send(:sample_value, :boolean, true)
      assert_instance_of Date,            @generator.send(:sample_value, :date, true)
      assert_instance_of DateTime,        @generator.send(:sample_value, :datetime, true)
      assert_equal BigDecimal(123.45, 2), @generator.send(:sample_value, :decimal, true)
      assert_equal 123.45,                @generator.send(:sample_value, :float, true)
      assert_equal 123,                   @generator.send(:sample_value, :integer, true)
      assert_equal 123,                   @generator.send(:sample_value, :numeric, true)
      assert_equal 'MyString',            @generator.send(:sample_value, :string, true)
      assert_equal 'MyText',              @generator.send(:sample_value, :text, true)
      assert_instance_of Time,            @generator.send(:sample_value, :time, true)
      assert_equal 'unknown',             @generator.send(:sample_value, :something, true)
    end
  end

end
