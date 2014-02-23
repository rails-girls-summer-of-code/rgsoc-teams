class ApplicationFormMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM']

  default :to => "at@an-ti.eu"

  def new_application(application)

    @application = application
    mail(to: 'at@an-ti.eu', subject: '[RGSoC 2014] New Application')
  end
end
