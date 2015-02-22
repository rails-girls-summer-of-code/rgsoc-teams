class Season < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  before_validation :set_application_dates

  class << self
    def current
      find_or_create_by(name: Date.today.year.to_s)
    end
  end

  def application_period?
   Time.now.utc.between? applications_open_at, applications_close_at
  end

  private

  def set_application_dates
    self.applications_open_at  ||= DateTime.parse("03-01")
    self.applications_close_at ||= DateTime.parse("03-31")
    self.applications_open_at  = applications_open_at.utc.beginning_of_day
    self.applications_close_at = applications_close_at.utc.end_of_day
  end

end
