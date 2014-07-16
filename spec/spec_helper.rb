# simplecov on demand coverage spec.
# run with "COVERAGE=true bundle exec rake spec"
if ENV['COVERAGE'] || ENV['CI']
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
ENV['EMAIL_FROM'] ||= 'test@rg.com'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'cancan/matchers'
require 'sucker_punch/testing/inline'
require 'factory_girl_rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.order = 'random'

  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.extend ControllerMacros,     type: :controller
end
