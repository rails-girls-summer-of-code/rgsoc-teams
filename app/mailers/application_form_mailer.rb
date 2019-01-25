# frozen_string_literal: true

class ApplicationFormMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM'] || 'contact@rgsoc.org'
  default to: 'contact@rgsoc.org'

  helper ApplicationsHelper
  helper MarkdownHelper

  def new_application(application)
    @application = application
    mail(subject: "[RGSoC #{Season.current.year}] New Application: #{@application.name}")
  end

  def submitted(application:, student:)
    @application = application
    @student     = student
    mail to: student.email
  end
end
