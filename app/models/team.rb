class Team < ActiveRecord::Base
  include ProfilesHelper, HasSeason

  delegate :sponsored?, :voluntary?, to: :kind

  KINDS = %w(sponsored voluntary)

  validates :name, uniqueness: true, allow_blank: true
  # validate :must_have_members
  validate :disallow_multiple_student_roles

  attr_accessor :checked

  has_one :project, dependent: :destroy
  has_many :applications, dependent: :nullify, inverse_of: :team
  has_many :application_drafts, dependent: :nullify
  has_many :roles, dependent: :destroy
  has_many :members, class_name: 'User', through: :roles, source: :user
  Role::ROLES.each do |role|
    has_many role.pluralize.to_sym, -> { where(roles: { name: role }) }, class_name: 'User', through: :roles, source: :user
  end
  has_many :sources, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_one :last_activity, -> { order('id DESC') }, class_name: 'Activity'
  has_many :comments, -> { order('created_at DESC') }
  belongs_to :event
  has_many :status_updates, -> { where(kind: 'status_update') }, class_name: 'Activity'
  has_many :ratings, as: :rateable

  accepts_nested_attributes_for :roles, :sources, :project, allow_destroy: true

  before_create :set_number
  before_save :set_last_checked, if: :checked

  class << self
    def ordered(sort = {})
      order([sort[:order] || 'kind, name', sort[:direction] || 'asc'].join(' '))
    end

    def visible
      where("teams.invisible IS NOT TRUE OR teams.kind IN (?)", KINDS)
    end

    # Returns a base scope reflecting the relevant teams depending on what
    # phase of the running season we're currently in.
    def by_season_phase
      if Time.now.utc > Season.current.acceptance_notification_at
        Team.where season: Season.current, kind: %w(sponsored voluntary)
      else
        Team.visible.where season: Season.current
      end
    end
  end

  def application
    @application ||= applications.where(season_id: Season.current.id).first
  end

  # def rating
  #   values = students.map { |student| student.rating }.flatten
  #   rating = values.empty? ? 0 : values.inject(&:+) / values.size
  #   values = [rating] + ratings.map(&:value)
  #   values.empty? ? 0 : values.sum.to_f / values.size
  # end

  def rating(type = :mean, options = { bonus_points: true })
    Rating::Calc.new(self, type, options).calc
  end

  def combined_ratings
    ratings.to_a + students.map { |student| student.ratings }.flatten
  end

  def set_number
    self.number = Team.count + 1
  end

  def kind
    super.to_s.inquiry
  end

  def display_name
    chunks = [name]
    chunks << project.name if project
    chunks = chunks.select(&:present?)
    chunks[1] = "(#{chunks[1]})" if chunks[1]
    "Team #{chunks.join(' ')}"
  end

  def accepted?
    sponsored? || voluntary?
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

  private

  def set_last_checked
    self.last_checked_at = Time.now.utc
    self.last_checked_by = checked.is_a?(String) ? checked.to_i : checked.id
  end

  MSGS = {
    duplicate_student_roles_singular: '%s already is a student on another team.',
    duplicate_student_roles_plural: '%s already are students on another team.'
  }

  def disallow_multiple_student_roles
    students = User.with_role('student').where(id: roles.map(&:user_id)).where.not('roles.team_id' => id)
    return if students.empty?
    msg = MSGS[:"duplicate_student_roles_#{students.size == 1 ? 'singular' : 'plural'}"]
    errors.add :roles, msg % students.map(&:name).join(', ')
  end

  # def must_have_members
  #   errors.add(:team, 'must have at least one member') if members_empty?
  # end

  # def members_empty?
  #   roles.empty? or roles.all? { |role| role.marked_for_destruction? }
  # end
end
