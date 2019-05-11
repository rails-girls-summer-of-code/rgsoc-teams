# frozen_string_literal: true

module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, dependent: :destroy
    has_many :todos, dependent: :destroy
  end

  def average_points
    return 0 if rating_points.empty?
    mean(rating_points).round(2)
  end

  def median_points
    return 0 if rating_points.empty?
    m_pos = rating_points.size / 2

    if rating_points.size.odd?
      rating_points[m_pos].round(2)
    else
      mean(rating_points[m_pos - 1..m_pos]).round(2)
    end
  end

  def ratings_short
    ratings.includes(:user).map { |r| "#{r.user&.name}: #{r.points&.round(2)}" }
  end

  def total_picks
    ratings.where(pick: true).count
  end

  def total_likes
    ratings.where(like: true).count
  end

  private

  def rating_points
    ratings.map(&:points).sort
  end

  def mean(array)
    array.inject(0) { |sum, x| sum += x } / array.size.to_f
  end
end
