class CreatesApplicationFromDraft
  STUDENT_FIELDS = ApplicationDraft::STUDENT0_REQUIRED_FIELDS + ApplicationDraft::STUDENT1_REQUIRED_FIELDS

  delegate :team, to: :application_draft

  attr_reader :application_draft

  def initialize(application_draft)
    @application_draft = application_draft
  end

  def save
    application.save
  end

  def application
    @application ||= Application.new(application_attributes)
  end

  def application_attributes
    {
      team: team,
      application_draft: application_draft,
      application_data: application_data,
      season: application_draft.season,
    }
  end

  private

  def application_data
    {

    }.merge(student_attributes).merge(coaches_attributes)
  end

  def coaches_attributes
    %w(coaches_hours_per_week coaches_why_team_successful).each_with_object({}) do |attribute, hash|
      hash[attribute] = application_draft.send(attribute)
    end
  end

  def student_attributes
    STUDENT_FIELDS.each_with_object({}) do |attribute, hash|
      hash[attribute] = application_draft.send(attribute)
    end
  end
end
