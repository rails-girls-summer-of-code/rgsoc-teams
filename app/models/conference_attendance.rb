# frozen_string_literal: true

class ConferenceAttendance < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :conference, optional: true
end
