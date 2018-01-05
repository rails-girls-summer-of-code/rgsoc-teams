# simplecov on demand coverage spec.
# run with "COVERAGE=true bundle exec rake spec"
if ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
  )
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

ENV['EMAIL_FROM'] = FFaker::Internet.email



# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.expose_dsl_globally = false # disable RSpec < 3 global monkey patching
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'

  config.include ActiveJob::TestHelper
  config.include RSpecHtmlMatchers

  config.before(:suite) do
    WebMock.disable_net_connect!(
      allow: 'codeclimate.com',
      allow_localhost: true
    )
  end

  config.after(:each) do
    Timecop.return
  end
end
