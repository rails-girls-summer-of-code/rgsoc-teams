class Conference < ActiveRecord::Base

  include HasSeason

  has_many :attendances
  has_many :attendees, through: :attendances, source: :user
  validates :name, :round, presence: true

  accepts_nested_attributes_for :attendances

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }
  scope :current, -> { where(season: Season.current) }

  def tickets_left
    confirmed_attendances = attendances.select { |attendance| attendance.confirmed }
    tickets - confirmed_attendances.size
  end
end
