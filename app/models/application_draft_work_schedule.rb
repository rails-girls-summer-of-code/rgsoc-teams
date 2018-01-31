# frozen_string_literal: true
class ApplicationDraftWorkSchedule < ApplicationRecord
  belongs_to :work_schedule
  belongs_to :application_draft
end
