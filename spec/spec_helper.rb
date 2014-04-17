# simplecov on demand coverage spec.
# run with "COVERAGE=true bundle exec rake spec"
if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/spec'
    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
    coverage_dir File.join("coverage", Time.now.strftime("%Y%m%d-%H%M%S"))
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'cancan/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # config.backtrace_clean_patterns = []

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.extend ControllerMacros,     type: :controller
end

def random_name letters=rand(10)+10
  [*('a'..'z')].sample(letters).join
end

def random_email
  "#{random_name}@railsgirls.com"
end
