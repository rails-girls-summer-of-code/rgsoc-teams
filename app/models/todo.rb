class Todo < ApplicationRecord
  BLACK_FLAGS = %w(remote_team male_gender age_below_18 less_than_two_coaches zero_community)

  belongs_to :user
  belongs_to :application
  delegate   :season, to: :application

  def self.for_current_season
    includes(:user, application: [:team, :ratings, :season])
      .where(applications: { season: Season.current })
      .where.not(applications: { team: nil })
  end

  def rating
    Rating.find_by(user: user, application: application)
  end

  def eligible?
    application.flags.empty? || (application.flags & BLACK_FLAGS).empty?
  end

  def done?
    rating.present?
  end
end
