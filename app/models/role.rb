class Role < ActiveRecord::Base
  ROLES = %w{ student coach mentor }.freeze

  belongs_to :user
  belongs_to :team

  validates :user, presence: true
  validates :name, inclusion: { in: ROLES }, presence: true
  validates :user_id, uniqueness: { scope: [:name, :team_id] }

  def github_handle
    user.try(:github_handle)
  end

  def github_handle=(github_handle)
    self.user = github_handle.present? && User.where(github_handle: github_handle).first || build_user
    user.github_handle = github_handle
  end
end
