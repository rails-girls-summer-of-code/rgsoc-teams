class Role < ActiveRecord::Base
  ROLES = %w{ student coach mentor }.freeze

  belongs_to :member, class_name: 'User', foreign_key: 'user_id'
  belongs_to :team

  validates :user_id, :team_id, presence: true
  validates :name, inclusion: { in: ROLES }, presence: true

end
