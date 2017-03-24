class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :application
  delegate   :season, to: :application

  def self.for_current_season
    joins(:application)
      .where(applications: { season: Season.current })
      .where.not(applications: { team: nil })
  end
end
