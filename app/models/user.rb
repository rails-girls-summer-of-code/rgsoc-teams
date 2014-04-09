require 'github/user'

class User < ActiveRecord::Base
  TSHIRT_SIZES = %w(XXS XS S M L XL 2XL 3XL)
  URL_PREFIX_PATTERN = /\A(http|https).*/i

  ORDERS = {
    name:           "LOWER(users.name)",
    team:           "COALESCE(teams.name, teams.projects)",
    github:         "users.github_handle",
    irc:            "COALESCE(users.irc_handle, '')",
    location:       "users.location",
    interested_in:  "users.interested_in",
    country:        "users.country",
  }

  INTERESTS = {
    'pair'            => 'Finding a pair',
    'coaches'         => 'Finding coaches',
    'project'         => 'Finding a project',
    'coaching'        => 'Helping as a coach',
    'mentoring'       => 'Helping as a mentor for a project that I am part of',
    'helpdesk'        => 'Helping as a remote coach (helpdesk)',
    'organizing'      => 'Helping as an organizer',
    'deskspace'       => 'Providing office/desk space',
    'coachingcompany' => 'Providing a coaching team from our company',
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
  has_many :applications
  has_many :teams, -> { uniq }, through: :roles
  has_many :attendances
  has_many :conferences, through: :attendances

  validates :github_handle, presence: true, uniqueness: true
  validates :homepage, format: { with: URL_PREFIX_PATTERN }, allow_blank: true
  validates :country, presence: true, on: :update

  accepts_nested_attributes_for :attendances, allow_destroy: true

  before_create :sanitize_location
  after_create :complete_from_github

  class << self
    def ordered(order = nil, direction = 'asc')
      direction = direction == 'asc' ? 'ASC' : 'DESC'

      if order
        order = ORDERS.fetch(order.to_sym) { ORDERS.fetch(:name) }
      else
        order = ORDERS.fetch(:name)
      end

      scope = order("#{order} #{direction}").references(:teams)
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

    def with_all_associations_joined
      includes(:conferences).group("conferences.id").
      includes(:roles).group("roles.id").
      includes(roles: :team).group("teams.id")
    end

    def with_interest(interest)
      where(":interest = ANY(interested_in)", interest: interest)
    end

  end

  def just_created?
    !!@just_created
  end

  def name_or_handle
    name.present? ? name : github_handle
  end

  def admin?
    roles.admin.any?
  end

  private

  # Ensures that the location column either contains non-whitespace text, or is NULL
  # This ensures that sorting by location yields useful results
  def sanitize_location
    if self.name.to_s.strip.empty?
      self.name = nil
    end
  end

  def complete_from_github
    attrs = Github::User.new(github_handle).attrs rescue {}
    attrs = attrs.select { |key, value| send(key).blank? }
    attrs[:name] = github_handle if attrs[:name].blank?
    update_attributes attrs
    @just_created = true
  end
end
