class ApplicationDraft < ActiveRecord::Base

  include HasSeason

  include AASM

  # FIXME
  STUDENT0_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student0_#{m}" }
  STUDENT1_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student1_#{m}" }

  belongs_to :team
  belongs_to :updater, class_name: 'User'

  acts_as_list scope: :team

  scope :current, -> { where(season: Season.current) }

  validates :team, presence: true
  validates :coaches_hours_per_week, :coaches_why_team_successful, :project_name, :project_url, :project_plan, presence: true, on: :apply
  validates :misc_info, :heard_about_it, :voluntary, :voluntary_hours_per_week, presence: true, on: :apply
  validate :only_two_application_drafts_allowed, if: :team, on: :create
  validate :mentor_required, on: :apply

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
    student_proxy = StudentAttributeProxy.new(method, self)
    if student_proxy.matches?
      student_proxy.attribute
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

  aasm :column => :state, :no_direct_assignment => true do
    state :draft, :initial => true
    state :applied

    event :submit_application do
      after do |applied_at_time = nil|
        self.applied_at = applied_at_time || Time.now
      end

      transitions :from => :draft, :to => :applied, :guard => :ready?
    end
  end

  private

  def mentor_required
    unless (team || Team.new).mentors.any?
      errors.add(:base, 'You need at least one mentor on your team')
    end
  end

  def only_two_application_drafts_allowed
    unless team.application_drafts.where(season: season).count < 2
      errors.add(:base, 'Only two applications may be lodged')
    end
  end

  def set_current_season
    self.season ||= Season.current
  end
end
