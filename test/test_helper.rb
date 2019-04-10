require "simplecov"
SimpleCov.start do
  add_filter "/test/"
end


$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "grapethor"

require "minitest/autorun"

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
