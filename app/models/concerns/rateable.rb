module Rateable
  extend ActiveSupport::Concern
  included do
    has_many :ratings, as: :rateable
  end

  # public: Averagepoints that this rateable object got from reviewers.
  def average_points
    if ratings.count > 0
      ratings.collect(&:points).sum / ratings.count
    else
      0
    end
  end

  def ratings_short
    ratings.includes(:user).map { |r| "#{r.user.name}: #{r.points.round(2)}" }
  end

  def total_picks
    ratings.where(pick: true).count
  end

  def total_likes
    ratings.where(like: true).count
  end
end
