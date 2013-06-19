# See the wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, User, id: user.id
    # can :manage, Repository, id: Repository.where(team_id: team_ids), team_id: team_ids

    can :manage, Team do |team|
      team.new_record? || user.teams.include?(team)
    end

    can :manage, Role do |role|
      user.teams.include?(role.team)
    end

    can :manage, Repository do |repository|
      user.teams.include?(repository.team)
    end
  end
end
