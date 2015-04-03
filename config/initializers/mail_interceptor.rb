if Rails.env.development? && [ENV['MAILTRAP_USER'], ENV['MAILTRAP_PASSWORD']].all?(&:present?)
  require 'mail'
  require 'lib/mailer_interceptor'
  Mail.register_interceptor(MailInterceptor)
end
