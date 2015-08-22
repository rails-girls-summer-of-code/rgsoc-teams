class ApplicationDraft < ActiveRecord::Base
  include HasSeason

  include AASM

  # FIXME
  STUDENT0_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student0_#{m}" }
  STUDENT1_REQUIRED_FIELDS = Student::REQUIRED_DRAFT_FIELDS.map { |m| "student1_#{m}" }

  belongs_to :team
  belongs_to :updater, class_name: 'User'
  has_one    :application
  belongs_to :signatory, class_name: 'User', foreign_key: :signed_off_by

  acts_as_list scope: :team

  scope :current, -> { where(season: Season.current) }

  validates :team, presence: true
  validates :coaches_hours_per_week, :coaches_why_team_successful, :project_name, :project_url, :project_plan, presence: true, on: :apply
  validates :heard_about_it, presence: true, on: :apply
  validates :voluntary_hours_per_week, presence: true, on: :apply, if: :voluntary?
  validate :only_two_application_drafts_allowed, if: :team, on: :create
  validate :mentor_required, on: :apply

  validates *STUDENT0_REQUIRED_FIELDS, presence: true, on: :apply
  validates *STUDENT1_REQUIRED_FIELDS, presence: true, on: :apply

  before_validation :set_current_season

  attr_accessor :current_user

  Role::TEAM_ROLES.each do |role|
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
    #todo ?? also for state :final ? (see as_mentor in can_sign_off?)
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
    #add notice: 'Check your application here; this will not submit your application'
  end

  aasm :column => :state, :no_direct_assignment => true do
    state :draft, :initial => true    #started by students, drafting by students & coaches
    state :final
    state :applied
    state :signed_off

    event :finalize do #students only
      transitions :from => :draft, :to => :final, :guard => :ready?
      #add notice: 'Check your application here; this will not submit your application'
    end

    event :apply do
    after do |applied_at_time = nil|
      self.applied_at = applied_at_time || Time.now
      CreatesApplicationFromDraft.new(self).save
    end
      transitions :from => :final, :to => :applied, :guard => :can_submit?
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

  def can_submit?
    current_user.present? and as_student?
  end

  def can_sign_off?
    current_user.present? and as_mentor?
  end

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
