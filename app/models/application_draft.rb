class ApplicationDraft < ActiveRecord::Base

  include HasSeason

  belongs_to :team

  validates :team, presence: true

  before_validation :set_current_season

  attr_accessor :current_user

  Role::TEAM_ROLES.each do |role|
    define_method "as_#{role}?" do                       # def as_student?
      team.send(role.pluralize).include? current_user    #   team.students.include? current_user
    end                                                  # end
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

  private

  def set_current_season
    self.season ||= Season.current
  end
end
