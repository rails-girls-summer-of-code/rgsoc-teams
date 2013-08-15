require 'github/user'

class User < ActiveRecord::Base
  TSHIRT_SIZES = %w(XXS XS S M L XL 2XL 3XL)
  URL_PREFIX_PATTERN = /\A(http|https).*/i

  ORDERS = {
    name:   'LOWER(users.name || users.github_handle)',
    team:   'teams.name || teams.projects',
    github: 'users.github_handle',
    irc:    'users.irc_handle'
  }

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
  has_many :attendances
  has_many :conferences, through: :attendances

  validates :github_handle, presence: true, uniqueness: true
  validates :homepage, format: { with: URL_PREFIX_PATTERN }, allow_blank: true

  accepts_nested_attributes_for :attendances, allow_destroy: true

  after_create :complete_from_github

  class << self
    def ordered(order = nil)
      order = order.to_sym if order
      scope = order(ORDERS[order || :name]).references(:teams)
      scope = scope.joins(:teams).references(:teams) if order == :team
      scope
    end

    def with_role(name)
      joins(:roles).where('roles.name = ?', name)
    end

    def with_assigned_roles
      joins(:roles).where('roles.id IS NOT NULL')
    end

    def with_team_kind(kind)
      joins(:teams).where('teams.kind = ?', kind)
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
