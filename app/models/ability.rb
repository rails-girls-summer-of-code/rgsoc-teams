# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    # guest user
    can :read, [Activity, User, Team, Project, Conference]

    return unless signed_in?(user)

    # unconfirmed, logged in user
    can [:update, :destroy], User, id: user.id
    can :resend_confirmation_instruction, User, id: user.id

    return unless user.confirmed?

    # confirmed user
    can [:update, :destroy], User, id: user.id
    can :resend_confirmation_instruction, User, id: user.id
    can :read_email, User, hide_email: false
    can :create, Project
    can [:join, :create], Team
    can :index, Mailing
    can :read, Mailing do |mailing|
      mailing.recipient? user
    end
    can :create, Comment

    # Members in a team
    can [:update, :destroy], Team do |team|
      on_team?(user, team)
    end

    # current_student
    if user.student?
      cannot :create, Team do |team|
        on_team_for_season?(user, team.season)
      end
      can :create, ApplicationDraft if user.application_drafts.in_current_season.none?
      can :create, Conference
    end

    # supervisor
    # Use old code, see below

    # project submitter
    can [:update, :destroy], Project, submitter_id: user.id
    can :use_as_template, Project do |project|
      user == project.submitter && !project.season&.current?
    end

    # admin
    if user.admin?
      can :manage, :all
      # MEMO add "cannot's" only; and only after this line
      cannot :create, User # this only happens through GitHub
    end

    ################# REMAININGS FROM OLD FILE, # = rewritten above ############

    # FIXME Leave this in until issue #1001 is fixed
    # visibility of email address in user profile
    can :read_email, User, id: user.id unless user.hide_email?
    can :read_email, User if user.admin?
    can :read_email, User do |other_user|
      user.confirmed? && (supervises?(other_user, user) || !other_user.hide_email?)
    end
    can :read, :users_info if user.admin? || user.supervisor?

    can :update_conference_preferences, Team do |team|
      team.accepted? && team.students.include?(user)
    end

    can :see_offered_conferences, Team do |team|
      user.admin? || team.students.include?(user) || team.supervisors.include?(user)
    end

    can :accept_or_reject_conference_offer, Team do |team|
      team.students.include?(user)
    end

    # todo helpdesk team join
    can :join, Team do |team|
      team.helpdesk_team? and signed_in?(user) and user.confirmed? and !on_team?(user, team)
    end

    can :crud, Role do |role|
      user.admin? || on_team?(user, role.team)
    end

    can :crud, Source do |repo|
      user.admin? || on_team?(user, repo.team)
    end

    can :supervise, Team do |team|
      user.roles.organizer.any? || team.supervisors.include?(user)
    end

    can :crud, ConferencePreference do |preference|
      user.admin? || (preference.team.students.include? user)
    end
  end # initializer

  def signed_in?(user)
    user.persisted?
  end

  def on_team?(user, team)
    user.teams.include?(team)
  end

  def on_team_for_season?(user, season)
    season && user.roles.student.joins(:team).pluck(:season_id).include?(season.id)
  end

  def supervises?(user, supervisor)
    user.teams.in_current_season.any? { |team| team.supervisors.include?(supervisor) }
  end
end
