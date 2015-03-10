class RoleMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: ENV['EMAIL_FROM'] || 'summer-of-code-team@railsgirls.com'

  def user_added_to_team(role)
    @role = role
    mail to: @role.user.email,
         subject: "[rgsoc-teams] You have been added to the #{@role.team.name} team."
  end
end
