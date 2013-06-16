module ApplicationHelper
  def link_to_team_members(team, role = :member)
    team.send(role.to_s.pluralize).map do |student|
      link_to(h(student.name_or_handle), student)
    end.join(', ').html_safe
  end

  def link_to_user_teams(user)
    user.teams.map do |team|
      link_to(h(team.name), team)
    end.join(', ').html_safe
  end
end
