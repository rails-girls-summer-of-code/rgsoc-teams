# frozen_string_literal: true

class RoleMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: ENV['EMAIL_FROM'] || 'contact@rgsoc.org'

  def user_added_to_team(role)
    return unless role.user.present? &&
                  role.team.present? &&
                  role.user.email.present?
    @role = role
    mail to: @role.user.email,
         subject: "[rgsoc-teams] You have been added to the #{@role.team.name} team."
  end
end
