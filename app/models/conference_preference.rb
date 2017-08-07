class ConferencePreference < ActiveRecord::Base

  belongs_to :team, inverse_of: :conference_preferences
  belongs_to :conference, inverse_of: :conference_preferences
end
