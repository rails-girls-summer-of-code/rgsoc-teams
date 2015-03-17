class ApplicationDraft < ActiveRecord::Base

  include HasSeason

  # FIXME
  STUDENT0_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student0_#{m}" }
  STUDENT1_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student1_#{m}" }

  belongs_to :team
  belongs_to :updater, class_name: 'User'

  scope :current, -> { where(season: Season.current) }

  validates :team, presence: true
  validates :coaches_hours_per_week, :coaches_why_team_successful, :project_name, :project_url, presence: true, on: :apply
  validates :misc_info, :heard_about_it, :voluntary, :voluntary_hours_per_week, presence: true, on: :apply
  validate :only_two_application_drafts_allowed, if: :team, on: :create

  validates *STUDENT0_REQUIRED_FIELDS, presence: true, on: :apply
  validates *STUDENT1_REQUIRED_FIELDS, presence: true, on: :apply

  before_validation :set_current_season

  attr_accessor :current_user

  Role::TEAM_ROLES.each do |role|
    define_method "as_#{role}?" do                       # def as_student?
      team.send(role.pluralize).include? current_user    #   team.students.include? current_user
    end                                                  # end
  end

  def method_missing(method, *args, &block)
    if match = /^student([01])_(.*)/.match(method.to_s) and index = match[1].to_i and field = match[2]
      students[index].send(field) if students[index]
    else
      super
    end
  end

  def students
    if as_student?
      [ current_student, current_pair ].compact
    else
      team.students.order(:id)
    end.map { |user| Student.new(user) }
  end

  def current_student
    @current_student ||= team.students.detect{ |student| student == current_user }
  end

  def current_pair
    @current_pair ||= (team.students - [current_student]).first
  end

  def role_for(user)
    draft = dup.tap { |d| d.current_user = user }
    if draft.as_student?
      'Student'
    elsif draft.as_coach?
      'Coach'
    elsif draft.as_mentor?
      'Mentor'
    end
  end

  def ready?
    false # valid?(:apply)
  end

  def state
    (applied_at? ? 'applied' : 'draft').inquiry
  end

  private

  def only_two_application_drafts_allowed
    unless team.application_drafts.where(season: season).count < 2
      errors.add(:base, 'Only two applications may be lodged')
    end
  end

  def set_current_season
    self.season ||= Season.current
  end
end
