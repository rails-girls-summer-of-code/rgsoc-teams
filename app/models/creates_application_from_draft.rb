class CreatesApplicationFromDraft
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
    }
  end

  private

  def application_data
    {
      hours_per_coach: application_draft.coaches_hours_per_week
    }
  end
end
