source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails', '~> 5.1.2'
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
gem 'font-awesome-sass'
gem 'pretender'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'sprockets-rails'

gem 'newrelic_rpm'
gem 'aws-sdk'

gem 'sentry-raven'

gem 'aasm'
gem 'camo'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'byebug', require: !ENV['RM_INFO'] #require parameter is workaround for RubyMine with Rails ~> 4.1
  gem 'ffaker'
  gem 'jshint'
end

group :development do
  gem 'better_errors'
  # gem 'binding_of_caller'
  # gem 'jazz_hands'
  gem 'pry'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'foreman'
end

group :test do
  gem 'rails-controller-testing'
  gem 'shoulda'
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'coveralls', require: false
  gem 'timecop'
  gem "codeclimate-test-reporter", require: false
  gem 'rspec-collection_matchers'
  gem 'rspec-html-matchers'
  gem 'rspec-activemodel-mocks'
end
