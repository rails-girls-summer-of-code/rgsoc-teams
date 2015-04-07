class MailInterceptor
  def self.delivering_mail(message)
    message.to = `git config user.email`
    message.bcc = message.cc = nil
  end
end
