# frozen_string_literal: true

class Team < ApplicationRecord
  include HasSeason
  include ProfilesHelper

  KINDS = %w(full_time part_time)

  belongs_to :project, optional: true

  has_one :last_activity, -> { order('id DESC') }, class_name: 'Activity'
  has_one :conference_preference, dependent: :destroy

  has_many :applications, dependent: :nullify, inverse_of: :team
  has_many :application_drafts, dependent: :nullify
  has_many :roles, dependent: :destroy, inverse_of: :team
  has_many :members, through: :roles, source: :user
  Role::ROLES.each do |role|
    has_many role.pluralize.to_sym, -> { where(roles: { name: role }) }, through: :roles, source: :user
  end
  has_many :sources, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :status_updates, -> { where(kind: 'status_update') }, class_name: 'Activity'
  has_many :conference_attendances, dependent: :destroy

  accepts_nested_attributes_for :conference_preference, allow_destroy: true
  accepts_nested_attributes_for :roles, :sources, allow_destroy: true
  accepts_nested_attributes_for :conference_attendances, allow_destroy: true, reject_if: proc { |attributes| attributes[:conference_id].blank? }

  delegate :full_time?, to: :kind
  delegate :part_time?, to: :kind

  attr_accessor :checked

  validates :name, presence: true, uniqueness: true
  validate :disallow_multiple_student_roles
  validate :disallow_duplicate_members
  validate :limit_number_of_students
  validate :limit_number_of_coaches

  before_create :set_number
  before_save :set_last_checked, if: :checked

  scope :full_time, -> { where(kind: %w(full_time sponsored)) }
  scope :part_time, -> { where(kind: %w(part_time voluntary)) }
  scope :accepted, -> { full_time.or(part_time) }
  scope :visible, -> { where.not(invisible: true).or(accepted) }
  scope :in_current_season, -> { where(season: Season.current) }
  scope :in_previous_season, -> { by_season(Date.today.year - 1) }
  scope :by_season, ->(year) { joins(:season).where(seasons: { name: year }) }
  scope :in_nearest_season, -> { in_current_season.presence || in_previous_season }

  class << self
    def ordered(sort = {})
      order([sort[:order] || 'kind, name', sort[:direction] || 'asc'].join(' '))
    end

    # Returns a base scope reflecting the relevant teams depending on what
    # phase of the running season we're currently in.
    def by_season_phase
      if Time.now.utc > Season.current.acceptance_notification_at
        Team.in_current_season.accepted
      else
        Team.in_current_season.visible
      end
    end
  end

  def application
    @application ||= applications.find_by(season_id: Season.current.id)
  end

  # TeamPerformance for Supervisor's Dashboard
  def performance
    @performance ||= TeamPerformance.new(self)
  end

  def confirmed?
    two_students_present?
  end

  def set_number
    self.number = Team.count + 1
  end

  def kind
    super.to_s.inquiry
  end

  # TODO: refactor me...
  def display_name
    chunks = [name, project&.name].select(&:present?)
    chunks[1] = "(#{chunks[1]})" if chunks[1]
    chunks << "[#{season.name}]" if season && season != Season.current

    d_name = chunks.join ' '
    d_name =~ /team /i ? d_name : "Team #{d_name}"
  end

  def accepted?
    full_time? || part_time?
  end

  def admin_team?
    helpdesk_team? || organizers_team? || supervisors_team?
  end

  def helpdesk_team?
    name.to_s.downcase == 'helpdesk'
  end

  def organizers_team?
    name.to_s.downcase == 'organizers'
  end

  def supervisors_team?
    name.to_s.downcase == 'supervisors'
  end

  def students_location
    students.map(&:location).reject(&:blank?).uniq.to_sentence
  end

  def last_checked_by
    user_id = self[:last_checked_by]
    User.find(user_id) if user_id
  end

  def coaches_confirmed?
    coach_roles.all? { |role| role.confirmed? }
  end

  def confirmed_coaches
    roles.where(name: 'coach', state: 'confirmed')
  end

  def coach_roles
    roles.select { |role| role.name == 'coach' }
  end

  def student_index(user)
    students.ids.index(user.id)
  end

  private

  def set_last_checked
    self.last_checked_at = Time.now.utc
    self.last_checked_by = checked.is_a?(String) ? checked.to_i : checked.id
  end

  MSGS = {
    duplicate_student_roles_singular: "%s already is a student on another team for #{Season.current.name}.",
    duplicate_student_roles_plural: "%s already are students on another team for #{Season.current.name}."
  }

  def disallow_multiple_student_roles
    students = User.with_role('student').joins(roles: :team).where(id: roles.map(&:user_id)).
      where.not('roles.team_id' => id).where('teams.season_id' => season_id)
    return if students.empty?
    msg = MSGS[:"duplicate_student_roles_#{students.size == 1 ? 'singular' : 'plural'}"]
    errors.add :base, msg % students.map(&:name).join(', ')
  end

  def disallow_duplicate_members
    new_members = roles.map { |role| role.user }
    duplicate_role_users = new_members.find_all { |member| new_members.count(member) > 1 }.uniq
    return if duplicate_role_users.empty?
    msg = "%s can't have more than one role in this team!"
    errors.add :base, msg % duplicate_role_users.map(&:name).join(', ')
  end

  def limit_number_of_students
    return unless members_with_role('student').size > 2
    errors.add(:roles, 'there cannot be more than 2 students on a team.')
  end

  def limit_number_of_coaches
    return unless members_with_role('coach').size > 4
    errors.add(:roles, :too_many_coaches)
  end

  def members_with_role(role)
    roles.select { |r| r.name == role && !r.marked_for_destruction? }
  end

  def two_students_present?
    students.reload.select(&:persisted?).size == 2
  end
end
