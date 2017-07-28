# frozen_sring_literal: true

# nodoc
class ConferencePreference < ActiveRecord::Base
  belongs_to :conference_preference_info
  belongs_to :conference
end
