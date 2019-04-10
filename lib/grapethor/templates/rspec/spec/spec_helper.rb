ENV['RACK_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

RSpec.configure do |config|
  config.before :suite do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.maintain_test_schema!
  end if defined?(ActiveRecord)

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.around :each do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.include FactoryBot::Syntax::Methods
  config.before :suite do
    FactoryBot.find_definitions
  end
end
