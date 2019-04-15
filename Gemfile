source 'https://rubygems.org'

ruby File.read(".ruby-version")

gem 'pg'
gem 'puma'
gem 'rails', '~> 5.2.3'

gem 'aasm'
gem 'aws-sdk', '~> 2.10'
gem 'bootsnap', require: false
gem 'bootstrap-kaminari-views'
gem 'camo'
gem 'cancancan'
gem 'country_select'
gem 'devise'
gem 'feedjira'
gem 'gh'
gem 'kaminari'
gem 'nested_form'
gem 'omniauth-github'
gem 'pretender'
gem 'rails_autolink'
gem 'redcarpet'
gem 'simple_form'
gem 'slim-rails'
gem 'sucker_punch'

gem 'bootstrap-sass'
gem 'font-awesome-sass', '~> 4.7'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'sass-rails'
gem 'sprockets-rails'
gem 'uglifier'

gem 'newrelic_rpm'
gem 'sentry-raven'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug', require: !ENV['RM_INFO'] # require parameter is workaround for RubyMine with Rails ~> 4.1
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pry'
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener' # preview mail in browser instead of sending
end

group :test do
  gem 'capybara', '~> 2.18'
  gem 'capybara-screenshot'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'rspec-html-matchers'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'

  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end
