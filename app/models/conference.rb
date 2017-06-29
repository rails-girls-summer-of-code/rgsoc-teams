require 'csv'
class Conference < ActiveRecord::Base
  include HasSeason
  
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, source: :user
  # date validation disabled because of Conference imports: not all conferences have dates.
  # See PR for Issue #762
  # validates :name, :starts_on, :ends_on, presence: true
  validate :chronological_dates, if: proc { |conf| conf.starts_on && conf.ends_on }

  accepts_nested_attributes_for :attendances

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
    confirmed_attendances = attendances.select { |attendance| attendance.confirmed }
    tickets.to_i - confirmed_attendances.size
  end
  
end