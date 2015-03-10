RgsocTeams::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  if ENV['MAILTRAP_USER'].present? && ENV['MAILTRAP_PASSWORD'].present?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      user_name: ENV['MAILTRAP_USER'],
      password: ENV['MAILTRAP_PASSWORD'],
      address: 'mailtrap.io',
      domain: 'mailtrap.io',
      port: '2525',
      authentication: :cram_md5,
      enable_starttls_auto: true
    }
  else
    config.action_mailer.raise_delivery_errors = false
  end
  config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

  config.eager_load = false
end
