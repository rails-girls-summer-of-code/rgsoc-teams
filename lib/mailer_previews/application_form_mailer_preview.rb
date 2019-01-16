# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/
class ApplicationFormMailerPreview < ActionMailer::Preview
  def submitted
    application = Application.last
    student     = application.team.students.first
    ApplicationFormMailer.submitted(application: application, student: student)
  end
end
