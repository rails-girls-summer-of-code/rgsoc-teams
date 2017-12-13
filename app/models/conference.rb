# frozen_string_literal: true
require 'csv'
class Conference < ApplicationRecord
  REGION_LIST = [
    "Africa",
    "South America",
    "North America",
    "Europe",
    "Asia Pacific"
  ]

  include HasSeason

  has_many :conference_attendances, dependent: :destroy
  has_many :first_choice_conference_preferences, class_name: 'ConferencePreference', foreign_key: 'first_conference_id'
  has_many :second_choice_conference_preferences, class_name: 'ConferencePreference', foreign_key: 'second_conference_id'
  has_many :attendees, through: :first_choice_conference_preferences, source: :team
  has_many :attendees, through: :second_choice_conference_preferences, source: :team

  validates :name, :url, :city, :country, :region, presence: true
  validate :chronological_dates, if: proc { |conf| conf.starts_on && conf.ends_on }

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }
  scope :in_current_season, -> { where(season: Season.current) }

  def date_range
    @date_range ||= DateRange.new(start_date: starts_on, end_date: ends_on)
  end

  def chronological_dates
    unless starts_on <= ends_on
      errors.add(:ends_on, 'must be a later date than start date')
    end
  end

  def tickets_left
    confirmed_attendances = conference_preference.select { |conference_preference| conference_preference.confirmed }
    tickets.to_i - confirmed_attendances.size
  end
end
