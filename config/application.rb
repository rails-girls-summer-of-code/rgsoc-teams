require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RgsocTeams
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    config.action_mailer.default_url_options = { host: 'teams.railsgirlssummerofcode.org' }

    config.active_job.queue_adapter = :sucker_punch
  end
end
