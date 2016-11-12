class Conference < ActiveRecord::Base

  include HasSeason

  has_many :attendances
  has_many :attendees, through: :attendances, source: :user

  validates :name, :round, presence: true
  validate :chronology # custom validator

  accepts_nested_attributes_for :attendances

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }
  scope :in_current_season, -> { where(season: Season.current) }

  def tickets_left
    confirmed_attendances = attendances.select { |attendance| attendance.confirmed }
    tickets.to_i - confirmed_attendances.size
  end

  def chronology
    return unless starts_on.present?
    errors.add(:end_date, "must be later than start date") if starts_on > ends_on
  end
end