require 'github/user'

class User < ActiveRecord::Base
  TSHIRT_SIZES = %w(XXS XS S M L XL 2XL 3XL)

  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers
  include ProfilesHelper

  devise :omniauthable

  has_many :roles do
    def admin
      where(name: Role::ADMIN_ROLES)
    end
  end
  has_many :teams, -> { uniq }, through: :roles

  validates :github_handle, presence: true, uniqueness: true
  validates :homepage, format: { with: /\A(http|https).*/i }, allow_blank: true

  after_create :complete_from_github

  class << self
    def ordered
      order('LOWER(COALESCE(users.name, users.github_handle))')
    end

    def with_role(name)
      includes(:roles).where('roles.name = ?', name)
    end

    def with_assigned_roles
      includes(:roles).having('COUNT(roles.*) > 0').group('users.id, roles.id').references([:roles, :users])
    end

    def with_team_kind(kind)
      includes(:teams).where('teams.kind = ?', kind)
    end
  end

  def name_or_handle
    name.present? ? name : github_handle
  end

  def admin?
    roles.admin.any?
  end

  def complete_from_github
    attrs = Github::User.new(github_handle).attrs rescue {}
    update_attributes attrs.select { |key, value| send(key).blank? }
  end
end
