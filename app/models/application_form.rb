class ApplicationForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  FIELDS = [:student_name, :student_email,
            :about_student, :about_pair,
            :gender_identification_student, :gender_identification_pair,
            :location, :attended_rg_workshop,
            :coding_level, :coding_level_pair,
            :skills, :learing_summary, :learning_since_workshop, :learning_since_workshop_pair,
            :code_samples, :coaches, :hours_per_coach, :why_team_successful, :projects, :project_period, :minimum_money]

  MUST_FIELDS = FIELDS - [:minimum_money]

  attr_accessor *FIELDS

  validates_presence_of *MUST_FIELDS

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def fields
    FIELDS
  end

  def attributes
    fields.inject({}) { |result, field| result[field] = self.send(field); result }
  end
end
