# frozen_string_literal: true

module TeamsHelper
  def conference_exists_for?(team)
    conference_preference = team.conference_preference
    return false unless conference_preference.present? && conference_preference.persisted?
    [
      conference_preference.first_conference_id,
      conference_preference.second_conference_id
    ].any?
  end
end
