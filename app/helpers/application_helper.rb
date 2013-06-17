module ApplicationHelper
  def icon(type, text = nil)
    %Q{<i class="icon-#{type}"></i>#{text == nil ? '' : " #{text}"}}.html_safe
  end

  def link_to_repositories(team)
    team.repositories.map do |repository|
      link_to(repository.name, repository.url)
    end.join(', ').html_safe
  end

  def link_to_team_members(team, role = :member)
    team.send(role.to_s.pluralize).map do |student|
      link_to(student.name_or_handle, student)
    end.join(', ').html_safe
  end

  def link_to_user_roles(user)
    user.roles.map do |role|
      link_to("##{role.team.number} #{role.team.name} (#{role.name})", role.team) if role.team
    end.compact.join(', ').html_safe
  end

  def render_markdown(source)
    renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      safe_links_only: true,
      hard_wrap: true
    )
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(source)
  end
end
