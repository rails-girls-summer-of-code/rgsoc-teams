source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.0'
gem 'pg'
gem 'puma'
gem 'devise'
gem 'omniauth-github'
gem 'cancancan'
gem 'redcarpet'
gem 'simple_form'
gem 'nested_form'
gem 'gh', '~> 0.14'
gem 'feedjira', '~> 1.6.0'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'sucker_punch'
gem 'country_select'
gem 'hashr'
gem 'simple_statistics'
gem 'rails_autolink'
gem 'slim-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass-rails'
gem 'pretender'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier', '~> 2.7.0'
gem 'sprockets-rails'

gem 'newrelic_rpm'
gem 'aws-sdk', '~> 1.38.0'

gem 'rollbar'

gem 'aasm'
gem 'acts_as_list'
gem 'camo'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'byebug', require: !ENV['RM_INFO'] #require parameter is workaround for RubyMine with Rails ~> 4.1
  gem 'ffaker', '~> 2.2.0'
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
