class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers

  devise :registerable, :rememberable, :omniauthable

  belongs_to :team

  validates :name, :email, presence: true, uniqueness: true
  validates :location, presence: true
end
