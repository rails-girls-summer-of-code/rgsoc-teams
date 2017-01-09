# frozen_string_literal: true
class ApplicationFormMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM'] || 'contact@rgsoc.org'

  default to: 'contact@rgsoc.org'

  def new_application(application)
    @application = application
    mail(subject: "[RGSoC #{Season.current.year}] New Application: #{@application.name}")
  end
end
