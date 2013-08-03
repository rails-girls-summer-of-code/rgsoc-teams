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

  def format_conference_date(starts_on, ends_on)
    starts_on = starts_on.to_formatted_s(:short)
    ends_on = ends_on.to_formatted_s(:short)
    starts_on == ends_on ? starts_on : [starts_on, ends_on].join(' - ')
  end

  def format_conference_scholarships(tickets, flights, accomodation)
    result = "#{tickets} #{tickets == 1 ? 'ticket' : 'tickets'}"
    if flights && accomodation
      result << ", #{flights} #{flights == 1 ? 'flight' : 'flights'}/hotel"
    elsif flights
      result << ", #{flights} #{flights == 1 ? 'flight' : 'flights'}"
    elsif accomodation
      result << ", #{accomodation}x hotel"
    end
    result
  end

  def format_conference_twitter(twitter)
    twitter.to_s.starts_with?('@') ? link_to(twitter, "http://twitter.com/#{twitter.gsub('@', '')}") : twitter
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

  def links_to_users(users)
    users.map { |user| link_to(user.name.present? ? user.name : user.github_handle, user) }
  end

  def links_to_attendances(conference)
    conference.attendances.includes(:user).order('users.name || users.github_handle').map do |attendance|
      user = attendance.user
      link_to(user.name.present? ? user.name : user.github_handle, user, class: attendance.confirmed? ? 'confirmed' : '')
    end
  end

  def links_to_conferences(conferences, extra_info = false)
    conferences.map do |conference|
      text = conference.name
      text += " (#{conference.location}, #{format_conference_date(conference.starts_on, conference.ends_on)})" if extra_info
      link_to(text, conference)
    end
  end

  def links_to_user_teams(user)
    user.teams.map do |team|
      link_to(team.name || team.project, team, class: "team #{team.sponsored? ? 'sponsored' : ''}")
    end.map(&:html_safe)
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

  def link_to_team_members_with_irc_handle(team, role = :member)
    team.send(role.to_s.pluralize).sort_by(&:name_or_handle).map do |student|
      link_to_team_member_with_irc_handle(student)
    end.join.html_safe
  end

  def link_to_team_member_with_irc_handle(member)
    content_tag(:div, :class => :user) do
      image_tag(member.avatar_url || 'default_avatar.png', alt: member.name_or_handle) +
        link_to(member.name_and_irc_handle, member)
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
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    link_to title, sort: column, direction: direction
  end
end
