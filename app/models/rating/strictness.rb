# frozen_string_literal: true
class Rating::Strictness
  attr_reader :season

  class << self
    # Returns the strictness-adjusted rating points for each rated
    # application id of the current season.
    #
    # @return [Hash{Integer => Float}]
    def in_current_season; new.to_h end
  end

  def initialize(season = Season.current)
    @season = season
  end

  # Returns a datastructure that maps each application to its
  # strictness-adjusted rating points.
  #
  # @return [Hash{Integer => Float}]
  def adjusted_points_for_applications
    applications.each_with_object({}) do |application, map|
      map[application.id] = \
        # OPTIMIZE `application.ratings.count` causes an n+1 problem
        (application.ratings.sum(&strictness_adjusted_points) / application.ratings.count.to_f).round(2)
    end
  end

  alias to_h adjusted_points_for_applications

  # Returns a datastructure that maps each reviewer_id to their individually
  # calculated strictness.
  #
  # @return [Hash{Integer => Float}]
  def strictness_per_reviewer
    @strictness_per_reviewer ||= reviewer_ids.each_with_object({}) do |id, map|
      expected_value_for_all             = expected_value_for(reviewer_ids).to_f
      expected_value_for_single_reviewer = expected_value_for([id]).to_f

      map[id] = expected_value_for_all / expected_value_for_single_reviewer
    end
  end

  private

  def ratings
    @ratings ||= Rating
                  .joins('JOIN applications ON ratings.rateable_id = applications.id')
                  .where(rateable_type: 'Application')
                  .where('applications.season_id' => season.id)
  end

  # @return [Array<Integer>] list of IDs for all rated applications
  def application_ids
    @application_ids ||= ratings.pluck(:rateable_id)
  end

  # @return [Array<Application>] all rated applications
  def applications
    @applications ||= Application.includes(:ratings).where(id: application_ids)
  end

  # @return [Array<Integer>] list of IDs for all participating reviewers
  def reviewer_ids
    @reviewer_ids ||= ratings.pluck(:user_id).uniq
  end

  def strictness_adjusted_points
    ->(rating) { (rating.points * strictness_per_reviewer[rating.user_id]).to_f }
  end

  # @return [Float] for expected value for application raring of
  # given set of reviewers
  def expected_value_for(ids)
    # We are working with the ratings of
    # given reviewer_ids only
    rating_subgroup = ratings.where(user_id: ids)

    # Count the frequencies: How often did a specific
    # reviewer given a specic value? The relative frequencies
    # are used as probabilities
    distribution = rating_subgroup.each_with_object({}) do |rating, hash|
      hash[rating.points.to_s] ||= 0
      hash[rating.points.to_s]  += 1
    end

    # Calculate the expected value by sum over the
    # product of value multiplied by its probablity
    distribution.sum { |x, frequency_of_x| x.to_f * (frequency_of_x.to_f / rating_subgroup.count.to_f) }
  end
end
