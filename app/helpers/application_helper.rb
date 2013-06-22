module ApplicationHelper
  def icon(type, text = nil)
    %Q{<i class="icon-#{type}"></i>#{text == nil ? '' : " #{text}"}}.html_safe
  end

  def accessible_roles
    current_user.admin? ? Role::ROLES : Role::TEAM_ROLES
  end

  def if_present?(user, *attrs)
    yield if attrs.any? { |attr| user.send(attr).present? }
  end

  def each_handle(user, *names)
    names.each do |name|
      handle = user.send(:"#{name}_handle")
      url = user.send(:"#{name}_url") if user.respond_to?(:"#{name}_url")
      yield name, handle, url if handle.present?
    end
  end

  def list_sources(team)
    content_tag(:ul, class: 'sources') do
      team.sources.each do |source|
        concat content_tag(:li, link_to(source.url, source.url))
      end
    end
  end

  def link_to_team_members(team, role = :member)
    team.send(role.to_s.pluralize).map do |student|
      link_to(student.name_or_handle, student)
    end.join(', ').html_safe
  end

  def link_to_user_roles(user)
    user.roles.map do |role|
      links = [link_to(role.name.capitalize, users_path(role: role.name))]
      links << link_to(role.team.display_name, role.team) if role.team
      links.join(' at ')
    end.compact.join(', ').html_safe
  end

  def render_markdown(source)
    renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      safe_links_only: true,
      hard_wrap: true
    )
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(source || '')
  end
end
