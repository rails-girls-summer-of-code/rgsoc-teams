class Conference < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, through: :attendances, source: :user

  accepts_nested_attributes_for :attendances

  scope :ordered, ->(sort = {}) { order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' ')) }

  def tickets_left
    confirmed_attendances = attendances.select { |attendance| attendance.confirmed }
    tickets - confirmed_attendances.size
  end
end
