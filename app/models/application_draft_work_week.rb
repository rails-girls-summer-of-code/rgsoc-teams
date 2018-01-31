# frozen_string_literal: true
class ApplicationDraftWorkWeek < ApplicationRecord
  belongs_to :work_week
  belongs_to :application_draft
end
