class User < ActiveRecord::Base
  include Authentication::ActiveRecordHelpers

  devise :registerable, :rememberable, :omniauthable

  validates :name, :email, presence: true, uniqueness: true
  validates :location, presence: true
end
