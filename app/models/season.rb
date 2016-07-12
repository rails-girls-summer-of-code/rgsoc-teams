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
  def fake_proposals_phase
    update({
         starts_at: 6.months.from_now,
         ends_at: 9.months.from_now,
         applications_open_at: 3.months.from_now,
         applications_close_at: 4.months.from_now,
         acceptance_notification_at: 5.months.from_now,
         project_proposals_open_at: 4.weeks.ago,
         project_proposals_close_at: 4.weeks.from_now
    })
  end

  def fake_application_phase
    update({
        starts_at: 2.months.from_now,
        ends_at: 5.months.from_now,
        applications_open_at: 2.weeks.ago,
        applications_close_at: 2.weeks.from_now,
        acceptance_notification_at: 6.weeks.from_now
    })
  end

  def fake_coding_phase
    update({
        starts_at: 6.weeks.ago,
        ends_at: 6.weeks.from_now,
        applications_open_at: 4.months.ago,
        applications_close_at: 3.months.ago,
        acceptance_notification_at: 2.months.ago
    })
  end

  def back_to_reality
    update({
       name: Date.today.year,
       starts_at: Time.utc(Date.today.year, 7, 1),
       ends_at: Time.utc(Date.today.year, 9, 30),
       applications_open_at: Time.utc(Date.today.year, 3, 1),
       applications_close_at: Time.utc(Date.today.year, 3, 31),
       acceptance_notification_at: Time.utc(Date.today.year, 5, 1)
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
    self.acceptance_notification_at = acceptance_notification_at.utc.end_of_day
    self.project_proposals_open_at  = project_proposals_open_at.beginning_of_day
    self.project_proposals_close_at = project_proposals_close_at.end_of_day
  end

end
