# See the wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, :to => :crud

    can :crud, User, id: user.id
    can :crud, User if user.admin?

    can :crud, Team do |team|
      user.admin? or signed_in?(user) && team.new_record? or on_team?(user, team)
    end

    cannot :create, Team do |team|
      on_team_for_season?(user, team.season)
    end

    can :join, Team do |team|
      team.helpdesk_team? and signed_in?(user) and not on_team?(user, team)
    end

    can :crud, Role do |role|
      user.admin? or on_team?(user, role.team)
    end

    can :crud, Source do |repo|
      user.admin? or on_team?(user, repo.team)
    end

    can :supervise, Team do |team|
      user.roles.organizer.any? || team.supervisors.include?(user)
    end

    can :crud, Conference if user.admin?
    can :crud, Attendance do |attendance|
      user.admin? || user == attendance.user
    end

    can :read, Mailing do |mailing|
      mailing.recipient? user
    end
    can :crud, Mailing    if user.admin?
    can :crud, Submission if user.admin?
    can :crud, :comments  if user.admin?
    can :read, :users_info if user.admin? || user.supervisor?

    can :crud, Project do |project|
      user.admin? ||
        user == project.submitter
    end

    # activities
    can :read, :feed_entry
    can :read, :mailing if signed_in?(user)

    # applications
    can :create, :application_draft if user.student? && user.application_drafts.in_current_season.none?
  end

  def signed_in?(user)
    user.persisted?
  end

  def on_team?(user, team)
    user.teams.include?(team)
  end

  def on_team_for_season?(user, season)
    season && user.roles.student.joins(:team).pluck(:season_id).include?(season.id)
  end

end
