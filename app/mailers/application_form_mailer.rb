class ApplicationFormMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM'] || 'summer-of-code-team@railsgirls.com'

  default to: 'summer-of-code@railsgirls.com'

  def new_application(application)
    @application = application
    mail(subject: "[RGSoC 2014] New Application: #{@application.name}")
  end
end
