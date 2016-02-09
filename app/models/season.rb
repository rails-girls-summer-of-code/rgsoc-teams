class Season < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  before_validation :set_application_dates


  class << self
    def current
      find_or_create_by(name: Date.today.year.to_s)
    end

    def succ
      find_or_create_by(name: (Date.today.year+1).to_s)
    end

    # Project proposals open early. This predicate tells us if
    # we are in the transition phase after the current season's
    # coding period but before the new year (i.d. 'Season') begun.
    def transition?
      current.transition?
    end

    def projects_proposable?
      season = transition? ? succ : current
      Time.now.utc.between? \
        season.project_proposals_open_at,
        season.project_proposals_close_at
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

  def ended?
    Time.now.utc >= (ends_at || Date.today.end_of_year)
  end

  def year; name end

  # switch_phase: enables developers to easily switch
  # between time dependent settings in views
  def fake_application_phase
    update({
        starts_at: Date.today+2.months,
        ends_at: Date.today+5.months,
        applications_open_at: Date.today-2.weeks,
        applications_close_at: Date.today+2.weeks,
        acceptance_notification_at: Date.today+6.weeks
    })
  end

  def fake_coding_phase
    update({
        starts_at: Date.today-6.weeks,
        ends_at: Date.today+6.weeks,
        applications_open_at: Date.today-4.months,
        applications_close_at: Date.today-3.months,
        acceptance_notification_at: Date.today-2.months
    })
  end

  def transition?
    year == Date.today.year.to_s and ended?
  end

  private

  def set_application_dates
    return if year.blank?
    self.starts_at ||= Time.utc(year, 7, 1)
    self.ends_at   ||= Time.utc(year, 9, 30)
    self.applications_open_at  ||= Time.utc(year, 3, 1)
    self.applications_close_at ||= Time.utc(year, 3, 31)
    self.acceptance_notification_at ||= Time.utc(year, 5, 1)
    self.project_proposals_open_at  ||= Time.utc(year.to_i-1, 12, 1)
    self.project_proposals_close_at ||= Time.utc(year, 02, 1)
    self.applications_open_at  = applications_open_at.utc.beginning_of_day
    self.applications_close_at = applications_close_at.utc.end_of_day
    self.acceptance_notification_at = acceptance_notification_at.utc.end_of_day
    self.project_proposals_open_at  = project_proposals_open_at.beginning_of_day
    self.project_proposals_close_at = project_proposals_close_at.end_of_day
  end

end
