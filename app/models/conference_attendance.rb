class ConferenceAttendance < ApplicationRecord
  belongs_to :team
  belongs_to :conference
end
