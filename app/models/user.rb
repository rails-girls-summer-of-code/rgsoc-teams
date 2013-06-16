class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers

  devise :omniauthable

  has_many :roles
  has_many :teams, through: :roles

  validates :github_handle, presence: true, uniqueness: true

  def name_or_handle
    name || github_handle
  end

  def github_url
    "https://github.com/#{github_handle}"
  end
end
