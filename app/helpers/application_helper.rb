module ApplicationHelper
  def icon(type, text = nil)
    %Q{<i class="icon-#{type}"></i>#{text == nil ? '' : " #{text}"}}.html_safe
  end

  def link_to_team_members(team, role = :member)
    team.send(role.to_s.pluralize).map do |student|
      link_to(student.name_or_handle, student)
    end.join(', ').html_safe
  end

  def link_to_user_roles(user)
    user.roles.map do |role|
      link_to("#{role.team.name} (#{role.name})", role.team)
    end.join(', ').html_safe
  end
end
