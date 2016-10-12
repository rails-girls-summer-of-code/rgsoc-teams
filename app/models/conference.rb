class Conference < ActiveRecord::Base

  include HasSeason

  has_many :attendances
  has_many :attendees, through: :attendances, source: :user
  validates :name, :round, presence: true
  validate :valid_end_date, on: :create

  accepts_nested_attributes_for :attendances

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }
  scope :in_current_season, -> { where(season: Season.current) }

  def valid_end_date
    errors.add(:ends_on, "-date must be after start date") unless :ends_on >= :starts_on
  end

  def tickets_left
    confirmed_attendances = attendances.select { |attendance| attendance.confirmed }
    tickets.to_i - confirmed_attendances.size
  end
end