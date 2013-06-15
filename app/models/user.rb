class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers

  ROLES = %w{ student coach mentor }.freeze

  devise :omniauthable

  belongs_to :team

  validates :name, :email, presence: true, uniqueness: true
  validates :location, presence: true
  # validates :role, inclusion: { in: ROLES }, presence: true
end
