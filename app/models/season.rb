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

  def applications_open?
    Time.now.utc >= (applications_open_at || 1.week.from_now)
  end

  def started?
    Time.now.utc >= (starts_at || 1.week.from_now)
  end

  def year; name end

  private

  def set_application_dates
    self.applications_open_at  ||= Time.utc(Date.today.year, 3, 1)
    self.applications_close_at ||= Time.utc(Date.today.year, 3, 31)
    self.applications_open_at  = applications_open_at.utc.beginning_of_day
    self.applications_close_at = applications_close_at.utc.end_of_day
  end

end
