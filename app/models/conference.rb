require 'csv'
class Conference < ActiveRecord::Base
  include HasSeason

  has_many :conference_preferences, dependent: :destroy
  has_many :conference_preference_info, through: :conference_preferences
  has_many :attendees, through: :conference_preference_info, source: :team
  validates :name, presence: true
  validate :chronological_dates, if: proc { |conf| conf.starts_on && conf.ends_on }

  accepts_nested_attributes_for :conference_preferences

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
    confirmed_attendances = conference_preferences.select { |conference_preferences| conference_preferences.confirmed }
    tickets.to_i - confirmed_attendances.size
  end
end
