if ENV["CODECLIMATE_REPO_TOKEN"] # code coverage is set on CI-Server
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

# simplecov on demand coverage spec.
# run with "COVERAGE=true bundle exec rake spec"
if ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start 'rails' do
    add_filter '/spec'
    add_group 'Models', 'app/models'
    add_group 'Controllers', 'app/controllers'
    coverage_dir File.join('coverage', Time.now.strftime('%Y%m%d-%H%M%S'))
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'


require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'factory_girl_rails'

ENV['EMAIL_FROM'] = FFaker::Internet.email



# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'

  config.include ActiveJob::TestHelper
  config.include RSpecHtmlMatchers
  config.extend ControllerMacros,     type: :controller

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    WebMock.disable_net_connect! allow: 'codeclimate.com'
  end

  config.after(:each) do
    Timecop.return
  end
end
