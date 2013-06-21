require 'github/user'

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

  after_create :complete_from_github

  class << self
    def ordered
      order('LOWER(COALESCE(users.name, github_handle))')
    end

    def with_role(name)
      includes(:roles).where('roles.name = ?', name)
    end
  end

  def name_or_handle
    name.present? ? name : github_handle
  end

  def github_url
    "https://github.com/#{github_handle}"
  end

  def admin?
    roles.admin.any?
  end

  def complete_from_github
    attrs = Github::User.new(github_handle).attrs rescue {}
    update_attributes attrs.select { |key, value| send(key).blank? }
  end
end
