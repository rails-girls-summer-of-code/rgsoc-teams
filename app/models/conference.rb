class Conference < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, through: :attendances, source: :user

  accepts_nested_attributes_for :attendances

  class << self
    def ordered(sort)
      order([sort[:order] || 'starts_on, name', sort[:direction] || 'asc'].join(' '))
    end
  end

  def tickets_left
    tickets - attendances.size
  end
end
