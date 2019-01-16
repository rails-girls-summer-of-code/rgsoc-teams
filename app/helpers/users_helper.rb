# frozen_string_literal: true

module UsersHelper
  def teams_for(user)
    user == current_user ? user.teams : user.teams.visible
  end
end
