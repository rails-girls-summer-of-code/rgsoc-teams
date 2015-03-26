if Rails.env.development? && [ENV['MAILTRAP_USER'], ENV['MAILTRAP_PASSWORD']].all?(&:present?)
  Mail.register_interceptor(MailInterceptor)
end
