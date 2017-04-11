# frozen_string_literal: true
class Rating::Strictness
  class << self

    def ratings
      Rating
        .joins('JOIN applications ON ratings.rateable_id = applications.id')
        .where(rateable_type: 'Application')
        .where(season_id: Season.current.id)
    end

    def reviewer_ids
      ratings.pluck(:user_id).uniq
    end

  end
end
