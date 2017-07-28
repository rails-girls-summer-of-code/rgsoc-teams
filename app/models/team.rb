class Team < ActiveRecord::Base
  include ProfilesHelper, HasSeason

  delegate :sponsored?, :voluntary?, to: :kind

  KINDS = %w(sponsored voluntary)

  validates :name, presence: true, uniqueness: true
  # validate :must_have_members
  validate :disallow_multiple_student_roles
  validate :disallow_duplicate_members
  validate :limit_number_of_students

  attr_accessor :checked

  has_many :applications, dependent: :nullify, inverse_of: :team
  has_many :application_drafts, dependent: :nullify
  has_many :roles, dependent: :destroy, inverse_of: :team
  has_many :members, class_name: 'User', through: :roles, source: :user
  Role::ROLES.each do |role|
    has_many role.pluralize.to_sym, -> { where(roles: { name: role }) }, class_name: 'User', through: :roles, source: :user
  end
  has_many :sources, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_one :last_activity, -> { order('id DESC') }, class_name: 'Activity'
  has_many :comments, as: :commentable
  has_many :status_updates, -> { where(kind: 'status_update') }, class_name: 'Activity'
  has_one :conference_preference_info, dependent: :destroy
  has_many :conference_preferences, through: :conference_preference_info, dependent: :destroy
  has_many :conferences, through: :conference_preferences

  accepts_nested_attributes_for :conference_preference_info, allow_destroy: true#, reject_if: :without_preferences?
  accepts_nested_attributes_for :conference_preferences, allow_destroy: true#, reject_if: :without_preferences?
  accepts_nested_attributes_for :roles, :sources, allow_destroy: true

  before_create :set_number
  before_save :set_last_checked, if: :checked

  scope :without_recent_log_update, -> {
    where.not(id: Activity.where(kind: ['status_update', 'feed_entry']).where("created_at > ?", 26.hours.ago).pluck(:team_id))
  }

  scope :accepted, -> { where(kind: %w(sponsored voluntary)) }

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
        Team.in_current_season.selected
      else
        Team.in_current_season.visible
      end
    end

    def in_current_season
      where(season: Season.current)
    end

    def selected
      where(kind: %w(sponsored voluntary))
    end

  end

  def application
    @application ||= applications.where(season_id: Season.current.id).first
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

  def display_name
    chunks = [name, project_name].select(&:present?)
    chunks[1] = "(#{chunks[1]})" if chunks[1]
    chunks << "[#{season.name}]" if season && season != Season.current

    d_name = chunks.join ' '
    d_name =~ /team /i ? d_name : "Team #{d_name}"
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

  def coaches_confirmed?
    coach_roles.all? { |role| role.confirmed? }
  end

  def confirmed_coaches
    roles.where(name: 'coach', state: 'confirmed')
  end

  def coach_roles
    roles.select { |role| role.name == 'coach' }
  end

  def with_all_built
    build_conference_preference_info unless conference_preference_info.present?
    conference_preference_info.with_preferences_build unless conference_preference_info.conference_preferences.present?
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
    students = roles.select{|r| r.name == 'student' && !r.marked_for_destruction?}
    return unless students.size > 2
    errors.add(:roles, 'there cannot be more than 2 students on a team.')
  end

  def two_students_present?
    students.reload.select(&:persisted?).size == 2
  end

  def without_preferences?(att)
    att[:conference_id].blank?
  end

  def without_conferences?(att)
    att[:conference_id].blank?
  end


  # def must_have_members
  #   errors.add(:team, 'must have at least one member') if members_empty?
  # end

  # def members_empty?
  #   roles.empty? or roles.all? { |role| role.marked_for_destruction? }
  # end
end
