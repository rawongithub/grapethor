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

end
