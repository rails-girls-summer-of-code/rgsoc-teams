source 'https://rubygems.org'

ruby File.read(".ruby-version")

gem 'rails', '~> 5.1.6'
gem 'pg'
gem 'puma'
gem 'devise'
gem 'omniauth-github'
gem 'cancancan'
gem 'redcarpet'
gem 'simple_form'
gem 'nested_form'
gem 'gh'
gem 'feedjira'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'sucker_punch'
gem 'country_select'
gem 'rails_autolink'
gem 'slim-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass', '~> 5.6'
gem 'pretender'
gem 'bootsnap', require: false

gem 'sass-rails'
gem 'uglifier'
gem 'sprockets-rails'

gem 'newrelic_rpm'
gem 'aws-sdk', '~> 2.10'

gem 'sentry-raven'

gem 'aasm'
gem 'camo'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'byebug', require: !ENV['RM_INFO'] # require parameter is workaround for RubyMine with Rails ~> 4.1
  gem 'ffaker'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'letter_opener' # preview mail in browser instead of sending
end

group :test do
  gem 'capybara', '~> 2.18'
  gem 'capybara-screenshot'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'rspec-html-matchers'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end
