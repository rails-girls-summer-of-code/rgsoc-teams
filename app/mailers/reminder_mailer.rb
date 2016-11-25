# frozen_string_literal: true
class ReminderMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: ENV['EMAIL_FROM'] || 'summer-of-code@railsgirls.com'

  def update_log(team)
    @team = team
    mail subject: subject, to: team.students.pluck(:email)
  end

  private
    def subject
      "[rgsoc-teams] Reminder: please update your team log"
    end
end
