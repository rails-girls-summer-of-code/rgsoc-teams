module Rateable
  extend ActiveSupport::Concern
  included do
    has_many :ratings, as: :rateable
  end

  def average_points
    total_points.round(2)
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

  private

  def total_points
    return 0 unless ratings.present?
    ratings.map(&:points).sum / ratings.count
  end
end
