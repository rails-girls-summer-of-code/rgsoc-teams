module ApplicationHelper
  def with_layout(layout)
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{layout}"
  end

  def icon(type, text = nil)
    %Q{<i class="icon-#{type}"></i>#{text == nil ? '' : " #{text}"}}.html_safe
  end

  def admin?
    current_user.try(:admin?)
  end

  def can_see_private_info?
    admin? || current_user == @user
  end

  def accessible_roles
    current_user.admin? ? Role::ROLES : Role::TEAM_ROLES
  end

  def format_date(date, format = :short)
    date && date.to_date.to_formatted_s(format) || '-'
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

  def team_group_emails(team)
    %w(students members).map do |group|
      emails = team.send(group).map(&:email).select(&:present?)
      [group.capitalize, emails] if emails.present?
    end.compact
  end

  def link_to_team_members(team, role = :member)
    team.send(role.to_s.pluralize).sort_by(&:name_or_handle).map do |student|
      link_to_team_member(student)
    end.join.html_safe
  end

  def link_to_team_member(member)
    content_tag(:div, :class => :user) do
      image_tag(member.avatar_url || 'default_avatar.png', alt: member.name_or_handle) +
        link_to(member.name_or_handle, member)
    end
  end

  def link_to_user_roles(user)
    user.roles.map do |role|
      links = [link_to(role.name.capitalize, users_path(role: role.name))]
      links << link_to(role.team.display_name, role.team) if role.team
      links.join(' at ')
    end.compact.join(', ').html_safe
  end

  def role_names(team, user)
    team.roles.select{|role| role.user == user}.map do |role|
      role.name.titleize
    end.join(', ').html_safe
  end

  # stolen from: http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end
end
