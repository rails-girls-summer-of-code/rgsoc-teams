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

  # TODO: rough version including index - make this better...
  def application_submitted(application:, student:)
    @application = application
    @student = student
    @student_index = application.team.students.first == student ? 0 : 1
    subject = 'your application bla bla'
    mail subject: subject, to: student.email
  end
end
