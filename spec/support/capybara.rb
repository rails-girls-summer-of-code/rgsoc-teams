require 'capybara-screenshot/rspec'
require 'selenium/webdriver'

Capybara.configure do |config|
  config.default_driver = :selenium_chrome_headless
  config.javascript_driver = :selenium_chrome_headless

  config.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3.
  # If you prefer to use XPath just remove this line and adjust any selectors
  # in your steps to use the XPath syntax.
  config.default_selector = :css

  # Ignore hidden elements on the page:
  config.ignore_hidden_elements = true

  config.always_include_port = true

  # Render error pages (helpful for e.g. testing 404s)
  config.raise_server_errors = false
end
