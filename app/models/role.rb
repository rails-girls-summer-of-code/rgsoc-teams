class Role < ActiveRecord::Base
  include GithubHandle

  TEAM_ROLES  = %w(student coach mentor)
  OTHER_ROLES = %w(helpdesk reviewer supervisor)
  ADMIN_ROLES = %w(organizer developer)
  ROLES = TEAM_ROLES + OTHER_ROLES + ADMIN_ROLES

  GUIDE_ROLES = %w(coach mentor supervisor)
  CONTRIBUTOR_ROLES = ADMIN_ROLES + GUIDE_ROLES

  belongs_to :user
  belongs_to :team

  validates :user, presence: true
  validates :name, inclusion: { in: ROLES }, presence: true
  validates :user_id, uniqueness: { scope: [:name, :team_id] }

  after_create :send_notification, if: Proc.new { GUIDE_ROLES.include?(self.name) }

  class << self
    def includes?(role_name)
      !where(name: role_name).empty?
    end
  end

  private

  def send_notification
    RoleMailer.user_added_to_team(self).deliver_later
  end
end
