class RoleMailerPreview < ActionMailer::Preview
  def user_added_to_team
    RoleMailer.user_added_to_team(Role.first)
  end
end
