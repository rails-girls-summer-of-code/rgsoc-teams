# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/role_mailer
class RoleMailerPreview < ActionMailer::Preview
  def user_added_to_team
    RoleMailer.user_added_to_team(Role.first)
  end

  def coach_added_to_team
    RoleMailer.user_added_to_team(Role.where(name: 'coach').first)
  end

  def supervisor_added_to_team
    role = Role.where(name: 'supervisor').first
    RoleMailer.user_added_to_team role
  end
end
