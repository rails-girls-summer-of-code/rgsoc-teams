# frozen_string_literal: true

class Conference < ApplicationRecord
  include HasSeason

  REGION_LIST = [
    "Africa",
    "South America",
    "North America",
    "Europe",
    "Asia Pacific"
  ]

  has_many :conference_attendances, dependent: :destroy
  has_many :first_choice_conference_preferences, class_name: 'ConferencePreference', foreign_key: 'first_conference_id', dependent: :destroy
  has_many :second_choice_conference_preferences, class_name: 'ConferencePreference', foreign_key: 'second_conference_id', dependent: :destroy

  validates :name, :url, :city, :country, :region, presence: true
  validate :chronological_dates

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }
  scope :in_current_season, -> { where(season: Season.current) }

  def date_range
    @date_range ||= DateRange.new(start_date: starts_on, end_date: ends_on)
  end

  private

  def chronological_dates
    return unless starts_on && ends_on
    errors.add(:ends_on, 'must be a later date than start date') unless starts_on <= ends_on
  end
end
