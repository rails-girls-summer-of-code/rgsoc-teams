require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RgsocTeams
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W(#{config.root}/app)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    config.action_mailer.default_url_options = { host: 'teams.railsgirlssummerofcode.org' }

    config.active_job.queue_adapter = :sucker_punch

    # Sentry config
    Raven.configure do |config|
      config.dsn = 'https://744f7c7520bf4217ac2d5cc60e5ef202:eee47d2a388b4d56b61b11536e8f9726@sentry.io/153582'
    end

    config.action_dispatch.show_exceptions = false

  end
end
