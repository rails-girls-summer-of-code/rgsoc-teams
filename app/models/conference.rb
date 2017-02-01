class Conference < ActiveRecord::Base
  include HasSeason

  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, source: :user

  validates :name, :round, presence: true
  validate :date_interval # custom validator

  accepts_nested_attributes_for :attendances

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }
  scope :in_current_season, -> { where(season: Season.current) }

  def tickets_left
    confirmed_attendances = attendances.select { |attendance| attendance.confirmed }
    tickets.to_i - confirmed_attendances.size
  end

  private

    def date_interval
      if [starts_on, ends_on].count(&:nil?) == 1
        errors.add(:base, 'Set both dates or none')
      elsif starts_on.to_s > ends_on.to_s
        errors.add(:ends_on, 'must be later than start date')
      end
    end
end
