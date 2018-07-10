require 'capybara-screenshot/rspec'
require 'selenium/webdriver'

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu --window-size=1024,1300] }
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

# Enable new driver to save screenshots
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.configure do |config|
  config.default_driver = :headless_chrome
  config.javascript_driver = :headless_chrome

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
