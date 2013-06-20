class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers

  devise :omniauthable

  has_many :roles do
    def admin
      where(name: Role::ADMIN_ROLES)
    end
  end
  has_many :teams, through: :roles

  validates :github_handle, presence: true, uniqueness: true

  def name_or_handle
    name.present? ? name : github_handle
  end

  def github_url
    "https://github.com/#{github_handle}"
  end

  def admin?
    roles.admin.any?
  end
end
