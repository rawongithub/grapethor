require 'rake/testtask'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('../../config/environment', __dir__)
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end

task default: :test
