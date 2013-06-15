class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers

  devise :registerable, :rememberable, :omniauthable

  validates :name, :email, presence: true, uniqueness: true
  validates :location, presence: true
end
