# frozen_string_literal: true
class Rating::Strictness

  def ratings
    @ratings ||= Rating
                  .joins('JOIN applications ON ratings.rateable_id = applications.id')
                  .where(rateable_type: 'Application')
                  .where('applications.season_id' => Season.current.id)
  end

  def reviewer_ids
    @reviewer_ids ||= ratings.map(&:user_id).uniq
  end

end
