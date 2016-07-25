class ApplicationDraft < ActiveRecord::Base
  include HasSeason

  include AASM

  # FIXME
  STUDENT0_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student0_#{m}" }
  STUDENT1_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student1_#{m}" }

  belongs_to :team
  belongs_to :updater, class_name: 'User'
  belongs_to :project1, class_name: 'Project'
  belongs_to :project2, class_name: 'Project'
  has_one    :application
  belongs_to :signatory, class_name: 'User', foreign_key: :signed_off_by

  scope :in_current_season, -> { where(season: Season.current) }

  validates :team, presence: true
  validates :project1, :project_plan, presence: true, on: :apply
  validates :heard_about_it, presence: true, on: :apply
  validates :working_together, presence: true, on: :apply
  validates :why_selected_project, presence: true, on: :apply
  validates :voluntary_hours_per_week, presence: true, on: :apply, if: :voluntary?
  validate :only_one_application_draft_allowed, if: :team, on: :create
  validate :different_projects_required
  validate :accepted_projects_required, on: :apply

  validates *STUDENT0_REQUIRED_FIELDS, presence: true, on: :apply
  validates *STUDENT1_REQUIRED_FIELDS, presence: true, on: :apply

  before_validation :set_current_season

  attr_accessor :current_user

  Role::FULL_TEAM_ROLES.each do |role|
    define_method "as_#{role}?" do                                     # def as_student?
      (team || Team.new).send(role.pluralize).include? current_user    #   team.students.include? current_user
    end                                                                # end
  end

  def respond_to_missing?(method, *)
    StudentAttributeProxy.new(method, self).matches? || super
  end

  def method_missing(method, *args, &block)
    student_proxy = StudentAttributeProxy.new(method, self)
    if student_proxy.matches?
      student_proxy.attribute
    else
      super
    end
  end

  def projects
    [project1, project2]
  end

  def students
    if as_student?
      [ current_student, current_pair ].compact
    else
      (team || Team.new).students.order(:id)
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
    valid?(:apply)
  end

  aasm :column => :state, :no_direct_assignment => true do
    state :draft, :initial => true
    state :applied
    state :signed_off

    event :submit_application do
      after do |applied_at_time = nil|
        self.applied_at = applied_at_time || Time.now
        CreatesApplicationFromDraft.new(self).save
      end

      transitions :from => :draft, :to => :applied, :guard => :ready?
    end

    event :sign_off, :guard => :can_sign_off? do
      after do
        update(
          signed_off_by: current_user.id,
          signed_off_at: Time.now.utc
        )
        application.sign_off! as: current_user
      end

      transitions :from => :applied, :to => :signed_off
    end
  end

  private

  def can_sign_off?
    current_user.present? and as_mentor?
  end

  def different_projects_required
    if project1 && project1 == project2
      errors.add(:projects, 'must not be selected twice')
    end
  end

  def accepted_projects_required
    if projects.any? { |p| p && !p.accepted? } # if they don't exist, the presence validation will handle it
      errors.add(:projects, 'must have been accepted')
    end
  end

  def only_one_application_draft_allowed
    unless team.application_drafts.where(season: season).none?
      errors.add(:base, 'Only one application may be lodged')
    end
  end

  def set_current_season
    self.season ||= Season.current
  end
end
