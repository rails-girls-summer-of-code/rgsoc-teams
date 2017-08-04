module TeamsHelper

  def conference_exists_for(team)
    team&.conference_preference&.persisted? && team&.conference_preference&.first_conference_id.present? || team&.conference_preference&.second_conference_id.present?
  end
end