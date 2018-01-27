# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/
class ApplicationFormMailerPreview < ActionMailer::Preview
  def application_submitted
    application = Application.last
    student     = application.team.students.first
    ApplicationFormMailer.application_submitted(application: application, student: student)
  end
end
