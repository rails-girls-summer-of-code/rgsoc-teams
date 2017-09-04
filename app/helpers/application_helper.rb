require 'cgi'
require 'uri'
module ApplicationHelper

  TIMEZONES = ActiveSupport::TimeZone.all.map{|t| t.tzinfo.name}.uniq.sort

  def show_application_link?
    current_season.application_period? ||
      (Time.now.utc.between? current_season.applications_close_at, current_season.acceptance_notification_at)
  end

  def application_disambiguation_link
    if current_user && current_user.application_drafts.in_current_season.any?
      link_to 'My Application', application_drafts_path
    else
      link_to 'Apply now', apply_path
    end
  end

  def avatar_url(user, size: 200)
    image = if user_avatar = user.avatar_url.presence
              "#{user_avatar}&s=#{size}"
            else
              'default_avatar.png'
            end
    image_tag image, alt: user.name_or_handle
  end

  def with_layout(layout)
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{layout}"
  end

  def admin?
    current_user.try(:admin?)
  end

  def coach?
    current_user.try(:coach?)
  end

  def can_see_private_info?
    current_user && (admin? || current_user == @user || current_user.roles.supervisor.any?)
  end

  def can_only_review_private_info?
    !admin? && current_user != @user
  end

  def accessible_roles
    current_user.admin? ? Role::ROLES : Role::TEAM_ROLES
  end

  def format_activity_content(activity, options = {})
    read_more = " &hellip; #{link_to('Read more.', activity.source_url)}"
    content = activity.content
    content = render_markdown(content) if activity.kind == 'mailing'
    content = strip_tags(content || '')
    content = CGI::unescapeHTML(content)
    content = sanitize(content, tags: [])
    content = truncate(content, options.merge(omission: '', separator: ' ')) { read_more.html_safe }
    content
  end

  def format_date(date, format = :long)
    date && l(date.to_date, format: format) || '-'
  end

  # Conferences

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

  def conference_tweet_link(conference)
    tweet = "I really want to go to #{conference.name} this year! #{conference.twitter} @Railsgirlssoc"
    "https://twitter.com/intent/tweet?text=#{URI.escape(tweet)}"
  end

  def format_conference_twitter(twitter)
    twitter.to_s.starts_with?('@') ? link_to(twitter, "http://twitter.com/#{twitter.gsub('@', '')}") : twitter
  end

  # @param conferences [Array<Conference>] a list of Conference records
  # @return [Array<String>] a list of HTML anchor tags to conferences
  def links_to_conferences(conferences)
    conferences.map do |conference|
      details = [conference.location, conference.date_range].reject(&:blank?).join(' – ')
      link_to("#{conference.name} (#{details})", conference)
    end
  end

  # end Conferences

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

  def links_to_user_teams(user)
    user.teams.map do |team|
      link_to(team.name || team.project, team, class: "team #{team.sponsored? ? 'sponsored' : ''}")
    end.map(&:html_safe)
  end

  def link_to_team_members(team, role = :member)
    team.send(role.to_s.pluralize).sort_by(&:name_or_handle).map do |student|
      link_to_team_member(student) + status_for(team, student, role)
    end.join.html_safe
  end

  def status_for(team, member, role_name)
    if role_name == :coach
      role = team.roles.find { |role| role.user == member}
      if role && role.confirmed?
        content_tag :span, 'Confirmed', class: 'label label-default'
      else
        if current_user == member
          link_to 'Confirm', confirm_role_path((role.confirmation_token || 'confirmation-token-missing')), method: :put, class: 'btn btn-sm btn-success'
        else
          content_tag :span, 'Not confirmed yet', class: 'label label-default'
        end
      end
    end
  end

  def link_to_team_member(member)
    content_tag(:li, :class => :user) do
      avatar_url(member, size: 40) +
        link_to(member.name_or_handle, member)
    end
  end

  def link_to_user_with_irc_handle(user)
    text = user.name_or_handle
    text = "#{text} (#{user.irc_handle})" if user.irc_handle.present?
    link_to(text, user)
  end

  def link_to_user_roles(user)
    user.roles.map do |role|
      links = [link_to(role.name.capitalize, community_index_path(role: role.name))]
      links << link_to(role.team.display_name, role.team) if role.team
      links.join(' at ')
    end.compact.join(', ').html_safe
  end

  def role_names(team, user)
    team.roles.reload.select{|role| role.user == user}.map do |role|
      role.name.titleize
    end.join(', ').html_safe
  end

  # stolen from: http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast
  def sortable(column, title = nil)
    title ||= column.to_s.titleize
    direction = (column.to_s == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    link_to title, params.except('action', 'controller').permit!.merge(sort: column, direction: direction)
  end

  def user_for_comment(comment)
    if comment.user.nil?
      "Deleted user"
    elsif comment.user == current_user
      "You"
    elsif comment.user.admin?
      comment.user.name + " " + content_tag(:small) do
        content_tag(:span, 'RGSoC', class: 'label label-primary')
      end
    else
      comment.user.name
    end
  end

  def time_for_user(user)
    if !user.timezone.blank?
      Time.use_zone(user.timezone) do
        localize(Time.zone.now, format: '%I:%M %p')
      end
    else
      '-'
    end
  end

  def list_all_timezones
    TIMEZONES
  end
end