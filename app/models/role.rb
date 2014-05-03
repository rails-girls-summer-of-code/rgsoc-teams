class Role < ActiveRecord::Base
  include GithubHandle

  TEAM_ROLES  = %w(student coach mentor)
  OTHER_ROLES = %w(helpdesk reviewer)
  ADMIN_ROLES = %w(supervisor organizer developer)
  ROLES = TEAM_ROLES + OTHER_ROLES + ADMIN_ROLES

  belongs_to :user
  belongs_to :team

  validates :user, presence: true
  validates :name, inclusion: { in: ROLES }, presence: true
  validates :user_id, uniqueness: { scope: [:name, :team_id] }

  class << self
    def includes?(role_name)
      !where(name: role_name).empty?
    end
  end
end
