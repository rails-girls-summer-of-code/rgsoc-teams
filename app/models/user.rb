class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers

  ROLES = %w{ student coach mentor }.freeze

  devise :omniauthable

  has_many :roles
  has_many :teams, through: :roles

  validates :github_handle, presence: true, uniqueness: true
  # validates :role, inclusion: { in: ROLES }, presence: true

  def name_or_handle
    name || github_handle
  end
end
