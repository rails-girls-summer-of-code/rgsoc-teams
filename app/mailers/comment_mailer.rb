class CommentMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: ENV['EMAIL_FROM'] || 'summer-of-code-team@railsgirls.com'

  attr_reader :team, :comment
  helper_method :team, :comment

  def email(comment)
    set comment
    recipients = supervisors.map(&:email).compact
    mail subject: subject, to: recipients.join(',') if recipients.any?
  end

  private

    def supervisors
      Role.where(name: 'supervisor').map(&:user).uniq.compact
    end

    def subject
      "[rgsoc-teams] New comment: #{team.name} - #{truncate(comment.text)}"
    end

    def set(comment)
      @team = comment.team
      @comment = comment
    end
end
