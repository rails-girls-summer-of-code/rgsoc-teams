# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    # guest user
    can :read, Activity # pro forma ; Activity has no authorisation restriction, except for kind: :mailing
    can :read, [User, Team, Project, Conference]

    return unless signed_in?(user)

    # unconfirmed, logged in user
    can :update, User, id: user.id
    can :resend_confirmation_instruction, User, id: user.id
    can :read_email, User, hide_email: false # view helper # delete? only used once

    return unless user.confirmed? && signed_in?(user)

    # confirmed user
    can [:update, :destroy], User, id: user.id
    can :resend_confirmation_instruction, User, id: user.id
    can :create, Project
    can [:join, :create], Team
    # the validation is tested in spec/models/team_spec.rb:33
    # Should this be in ability at all?
    # can :crud, Team do |team|
    #   team.new_record?
    # end
    #  => delete
    can :index, Mailing
    can :read, Mailing do |mailing|
      mailing.recipient? user
    end

    # Members in a team
    can [:update, :destroy], Team do |team|
      on_team?(user, team)
    end

    # Add / split restrictions for current season?

    # current_student
    if user.current_student? # TODO is this the best check?
      can :create, Team if user.teams.none?
      can :create, Conference
    end

    # supervisor
    if user.supervisor?
      can :read, :users_info
      # explanation for this simpler declaration:
      # The unconfirmed user ^ above had this declaration:
      #   `can :read_email, User, hide_email: false`
      # is defined for all users: all can read an email address that is not hidden
      # Here, the hide_email attribute doesnt matter: a supervisor can read it anyway
      # See specs added to check this behaviour
      can :read_email, User do |other_user|
        supervises?(other_user, user)
      end
    end

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

    ################# OLD FILE, # = moved to or rewritten above ############
    # NOT everything moved yet #

    # can :crud, Team do |team|
    #   user.admin? || signed_in?(user) && team.new_record? || on_team?(user, team)
    # end

    can :update_conference_preferences, Team do |team|
      team.accepted? && team.students.include?(user)
    end

    can :see_offered_conferences, Team do |team|
      user.admin? || team.students.include?(user) || team.supervisors.include?(user)
    end

    can :accept_or_reject_conference_offer, Team do |team|
      team.students.include?(user)
    end

    # cannot :create, Team do |team|
    #   on_team_for_season?(user, team.season) || !user.confirmed?
    # end
    # todo join helpdesk team
    can :join, Team do |team|
      team.helpdesk_team? and signed_in?(user) and user.confirmed? and not on_team?(user, team)
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

    # applications
    can :create, :application_draft if user.student? && user.application_drafts.in_current_season.none?

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
