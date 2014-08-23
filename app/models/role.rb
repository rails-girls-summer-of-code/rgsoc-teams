class Role < ActiveRecord::Base
  include GithubHandle

  TEAM_ROLES  = %w(student coach mentor)
  OTHER_ROLES = %w(helpdesk reviewer supervisor)
  ADMIN_ROLES = %w(organizer developer)
  ROLES = TEAM_ROLES + OTHER_ROLES + ADMIN_ROLES

  CONTRIBUTOR_ROLES = ADMIN_ROLES + %w(coach mentor)

  belongs_to :user
  belongs_to :team

  #validates :user, presence: true
  validates :name, inclusion: { in: ROLES }, presence: true
  validates :user_id, uniqueness: { scope: [:name, :team_id] }

  class << self
    def includes?(role_name)
      !where(name: role_name).empty?
    end
  end
end
