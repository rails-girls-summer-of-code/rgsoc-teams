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
      "n/a"
    end
  end
end
