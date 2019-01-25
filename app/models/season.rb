# frozen_string_literal: true

class Season < ApplicationRecord
  # Season's moments: [month, day]
  SUMMER_OPEN    = [7, 1]
  SUMMER_CLOSE   = [9, 30]
  APPL_OPEN      = [3, 1]
  APPL_CLOSE     = [3, 31]
  APPL_LETTER    = [5, 1]
  PROJECTS_OPEN  = [12, 1]
  PROJECTS_CLOSE = [2, 1]

  has_many :projects

  validates :name, presence: true, uniqueness: true, inclusion: { in: ('1999'..'2050') }

  before_validation :set_application_dates

  class << self
    def current
      find_or_create_by(name: Date.today.year.to_s)
    end

    def succ
      find_or_create_by(name: (Date.today.year + 1).to_s)
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

    def active_and_previous_years
      where("acceptance_notification_at <= ?", Time.now.utc).order(name: :desc).pluck(:name)
    end
  end

  def application_period?
    Time.now.utc.between? applications_open_at, applications_close_at
  end

  def applications_open?
    Time.now.utc >= (applications_open_at || 1.week.from_now)
  end

  def active?
    Time.now.utc.between?(acceptance_notification_at, ends_at)
  end

  # @return [Boolean] whether or not the Season represents the current year
  def current?
    name == Date.today.year.to_s
  end

  def started?
    Time.now.utc >= (starts_at || 1.week.from_now)
  end

  def ended?
    Time.now.utc >= (ends_at || Date.today.end_of_year).end_of_day.utc
  end

  def year; name end

  def transition?
    year == Date.today.year.to_s and ended?
  end

  private

  def set_application_dates
    return if year.blank?
    self.starts_at ||= Time.utc(year, *SUMMER_OPEN) # 1 jul
    self.ends_at ||= Time.utc(year, *SUMMER_CLOSE)  # 30 sept
    self.applications_open_at  ||= Time.utc(year, *APPL_OPEN)
    self.applications_close_at ||= Time.utc(year, *APPL_CLOSE)
    self.acceptance_notification_at ||= Time.utc(year, *APPL_LETTER) # 1 May
    self.project_proposals_open_at  ||= Time.utc(year.to_i - 1, *PROJECTS_OPEN)
    self.project_proposals_close_at ||= Time.utc(year, *PROJECTS_CLOSE)
    self.acceptance_notification_at = acceptance_notification_at.utc.end_of_day
    self.project_proposals_open_at  = project_proposals_open_at.beginning_of_day
    self.project_proposals_close_at = project_proposals_close_at.end_of_day
  end
end
