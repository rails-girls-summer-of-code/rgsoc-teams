# frozen_string_literal: true

class Recipients
  delegate :seasons, :group, :to, :cc, :bcc, to: :mailing

  attr_reader :mailing

  def initialize(mailing)
    @mailing = mailing
  end

  def emails
    ([cc, bcc] + user_emails).flatten.select(&:present?).map(&:downcase).uniq
  end

  def user_emails
    users.map(&:email)
  end

  def users
    return @users if @users
    @users = User.joins(:roles).where(roles: { name: roles })
    @users = @users.where('roles.team_id IN (?) OR roles.name IN (?)', teams, teamless_roles) if filter_by_teams?
    @users = @users.distinct
    @users
  end

  def filter_by_teams?
    group.to_sym != :everyone || seasons.any?
  end

  def teams
    return @teams if @teams
    @teams = Team
    @teams = @teams.where(kind: group.to_sym == :selected_teams ? Team::KINDS : nil) if group.to_sym != :everyone
    @teams = @teams.where(season: Season.where(name: seasons)) if seasons.any?
    @teams = @teams.select(:id).pluck(:id)
    @teams
  end

  def roles
    Array(to).map do |to|
      to == 'teams' ? %w(student coach mentor) : [to.singularize]
    end.flatten
  end

  def teamless_roles
    (roles & %w{organizer developer helpdesk})
  end
end
