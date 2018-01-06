# simplecov on demand coverage spec.
# run with "COVERAGE=true bundle exec rake spec"
# NOTE: This must remain at the top of this file.
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
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'
# Add additional requires below this line. Rails is not loaded until this point!

ENV['EMAIL_FROM'] = FFaker::Internet.email

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.expose_dsl_globally = false # disable RSpec < 3 global monkey patching
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

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

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
