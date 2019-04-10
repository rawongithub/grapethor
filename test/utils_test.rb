require "test_helper"

describe Grapethor::Utils do

  before do
    @generator = Grapethor::CLI.new
  end

  it '#alert' do
    msg = 'sample alert'
    out = "\n#{msg}\n\n"
    assert_output(out) do
      @generator.send(:alert, msg)
    end
  end


  it '#param_to_type' do
    assert 'Boolean', @generator.send(:param_to_type, :boolean)
    assert 'Date', @generator.send(:param_to_type, :date)
    assert 'DateTime', @generator.send(:param_to_type, :datetime)
    assert 'BigDecimal', @generator.send(:param_to_type, :decimal)
    assert 'Float', @generator.send(:param_to_type, :float)
    assert 'Integer', @generator.send(:param_to_type, :integer)
    assert 'String', @generator.send(:param_to_type, :string)
    assert 'Time', @generator.send(:param_to_type, :time)
    assert 'Unknown', @generator.send(:param_to_type, :something)
  end


  it '#sample_value' do
    assert true, @generator.send(:sample_value, :boolean)
    assert "'#{Date.today}'", @generator.send(:sample_value, :date)
    assert "'#{DateTime.now}'", @generator.send(:sample_value, :datetime)
    assert BigDecimal(123.45, 2), @generator.send(:sample_value, :decimal)
    assert 123.45, @generator.send(:sample_value, :float)
    assert 123, @generator.send(:sample_value, :integer)
    assert "'MyString'", @generator.send(:sample_value, :string)
    assert "'#{Time.now}'", @generator.send(:sample_value, :time)
    assert 'unknown', @generator.send(:sample_value, :something)
  end


  it '#sample_value for path' do
    assert true, @generator.send(:sample_value, :boolean, true)
    assert "#{Date.today}", @generator.send(:sample_value, :date, true)
    assert "#{DateTime.now}", @generator.send(:sample_value, :datetime, true)
    assert BigDecimal(123.45, 2), @generator.send(:sample_value, :decimal, true)
    assert 123.45, @generator.send(:sample_value, :float, true)
    assert 123, @generator.send(:sample_value, :integer, true)
    assert 'MyString', @generator.send(:sample_value, :string, true)
    assert "#{Time.now}", @generator.send(:sample_value, :time, true)
    assert 'unknown', @generator.send(:sample_value, :something, true)
  end

end
