require 'github/user'

class User < ActiveRecord::Base
  TSHIRT_SIZES = %w(XXS XS S M L XL 2XL 3XL)
  URL_PREFIX_PATTERN = /\A(http|https).*/i

  ORDERS = {
    name:           "LOWER(users.name)",
    team:           "teams.name",
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
    'coachingcompany' => 'Providing a coaching team from our company',
  }

  MONTHS_LEARNING = [
    "1-3",
    "4-6",
    "7-9",
    "10-12",
    "12-24",
    "24+",
  ]

  include ActiveModel::ForbiddenAttributesProtection
  include Authentication::ActiveRecordHelpers
  include ProfilesHelper

  devise :omniauthable

  has_many :roles do
    def admin
      where(name: Role::ADMIN_ROLES)
    end

    def organizer
      where(name: 'organizer')
    end

    def supervisor
      where(name: 'supervisor')
    end

    def student
      where(name: 'student')
    end
  end
  has_many :teams, -> { uniq }, through: :roles
  has_many :application_drafts, through: :teams
  has_many :attendances
  has_many :conferences, through: :attendances

  validates :github_handle, presence: true, uniqueness: true
  validates :homepage, format: { with: URL_PREFIX_PATTERN }, allow_blank: true

  accepts_nested_attributes_for :attendances, allow_destroy: true
  accepts_nested_attributes_for :roles

  before_save :sanitize_location
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

    def with_role(*names)
      joins(:roles).where('roles.name' => names)
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
    name.presence || github_handle
  end

  def admin?
    roles.admin.any?
  end

  def student?
    roles.student.any?
  end

  private

  # Ensures that the location column either contains non-whitespace text, or is NULL
  # This ensures that sorting by location yields useful results
  def sanitize_location
    self.location = nil if self.location.blank?
  end

  def complete_from_github
    attrs = Github::User.new(github_handle).attrs rescue {}
    attrs[:name] = github_handle if attrs[:name].blank?
    attrs = attrs.select { |key, value| send(key).blank? && value.present? }
    update_attributes attrs
    @just_created = true
  end
end
