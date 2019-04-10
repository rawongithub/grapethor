ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require_relative '../config/environment'
require 'active_record/fixtures'

ActiveRecord::Base.logger = nil
ActiveRecord::Migration.verbose = false

DatabaseCleaner.strategy = :transaction

require_rel './support/*'
