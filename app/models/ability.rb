# See the wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, User, id: user.id

    can :manage, Team do |team|
      user.admin? or signed_in?(user) && team.new_record? or on_team?(user, team)
    end

    can :manage, Role do |role|
      user.admin? or on_team?(user, role.team)
    end

    can :manage, Source do |repo|
      user.admin? or on_team?(user, repo.team)
    end
  end

  def signed_in?(user)
    user.persisted?
  end

  def on_team?(user, team)
    user.teams.include?(team)
  end
end
