# frozen_string_literal: true
# See the wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    can :crud, User, id: user.id
    can :crud, User if user.admin?
    can :resend_confirmation_instruction, User, id: user.id
    can :resend_confirmation_instruction, User if user.admin?

    # visibility of email address in user profile
    can :read_email, User, id: user.id if !user.hide_email?
    can :read_email, User if user.admin?
    can :read_email, User do |other_user|
      user.confirmed? && (supervises?(other_user, user) || !other_user.hide_email?)
    end

    can :crud, Team do |team|
      user.admin? || signed_in?(user) && team.new_record? || on_team?(user, team)
    end

    can :update_conference_preferences, Team do |team|
      team.accepted? && team.students.include?(user)
    end

    can :see_offered_conferences, Team do |team|
      user.admin? || team.students.include?(user) || team.supervisors.include?(user)
    end

    can :accept_or_reject_conference_offer, Team do |team|
      team.students.include?(user)
    end

    cannot :create, Team do |team|
      on_team_for_season?(user, team.season) || !user.confirmed?
    end

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

    can :crud, Conference if user.admin? || user.current_student?

    # todo add mailing controller and view for users in their namespace, where applicable
    can :read, Mailing do |mailing|
      mailing.recipient? user
    end

    can :crud, :comments if user.admin?
    can :read, :users_info if user.admin? || user.supervisor?

    can :crud, Project do |project|
      user.admin? ||
        (user.confirmed? && user == project.submitter)
    end

    can :create, Project if user.confirmed?
    cannot :create, Project if !user.confirmed?

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

  def supervises?(user, supervisor)
    user.teams.in_current_season.any? { |team| team.supervisors.include?(supervisor) }
  end

end
