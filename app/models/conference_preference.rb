class ConferencePreference < ActiveRecord::Base

  belongs_to :team, inverse_of: :conference_preferences
  belongs_to :first_conference, foreign_key: :first_conference_id, class_name: :conference
  belongs_to :second_conference, foreign_key: :second_conference_id, class_name: :conference
end
