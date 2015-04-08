class ApplicationForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  delegate :application, to: :team
  delegate :coaches, :mentors, to: :team

  FIELDS = [:student_name, :student_email,
            :about_student, :about_pair,
            :gender_identification_student, :gender_identification_pair,
            :location, :attended_rg_workshop,
            :coding_level, :coding_level_pair,
            :skills, :learing_summary, :learning_since_workshop, :learning_since_workshop_pair,
            :code_samples, :coaches, :hours_per_coach, :why_team_successful, :projects, :project_period,
            :minimum_money, :misc_info]

  MUST_FIELDS = FIELDS - [:misc_info, :minimum_money]

  attr_accessor *FIELDS

  attr_reader :current_user, :team

  validates_presence_of *MUST_FIELDS

  def initialize(team: Team.new, current_user: User.new, **attributes)
    @team, @current_user = team, current_user

    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end
  end

  def persisted?
    application.present?
  end

  Role::TEAM_ROLES.each do |role|
    define_method "as_#{role}?" do                       # def as_student?
      team.send(role.pluralize).include? current_user    #   team.students.include? current_user
    end                                                  # end
  end

  def students
    team.students.order(:id)
  end

  def student_index
    students.index(current_user) if as_student?
  end

  def student0_name
    students[0].name if students[0]
  end

  def student1_name
    students[1].name if students[1]
  end

  def student0_about
    students[0].application_about if students[0]
  end

  def student1_about
    students[1].application_about if students[1]
  end

  def student0_gender_identification
    students[0].application_gender if students[0]
  end

  def student1_gender_identification
    students[1].application_gender if students[1]
  end

  def student0_coding_level
    students[0].application_coding_level if students[0]
  end

  def student1_coding_level
    students[1].application_coding_level if students[1]
  end

  def student0_location
    students[0].application_location if students[0]
  end

  def student1_location
    students[1].application_location if students[1]
  end

  def fields
    FIELDS
  end

  def attributes
    fields.inject({}) { |result, field| result[field] = self.send(field); result }
  end
end
