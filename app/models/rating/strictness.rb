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
        application.ratings.sum(&strictness_adjusted_points) / application.ratings.count.to_f
    end
  end

  alias to_h adjusted_points_for_applications

  private

  def ratings
    @ratings ||= Rating
                  .joins('JOIN applications ON ratings.rateable_id = applications.id')
                  .where(rateable_type: 'Application')
                  .where('applications.season_id' => season.id)
  end

  # @return [Array<Integer>] list of IDs for all rated applications
  def application_ids
    @application_ids ||= ratings.map(&:rateable_id)
  end

  # @return [Array<Application>] all rated applications
  def applications
    @applications ||= Application.includes(:ratings).where(id: application_ids)
  end

  # @return [Array<Integer>] list of IDs for all participating reviewers
  def reviewer_ids
    @reviewer_ids ||= ratings.map(&:user_id).uniq
  end

  # @return [Float] overall rating average
  def average_points_per_reviewer
    @average_points_per_reviewer ||= ratings.sum(&:points) / reviewer_ids.size.to_f
  end

  # Returns a datastructure that maps each reviewer_id to their individually
  # calculated strictness.
  #
  # @return [Hash{Integer => Float}]
  def strictness_per_reviewer
    @strictness_per_reviewer ||= reviewer_ids.each_with_object({}) do |id, map|
      map[id] = average_points_per_reviewer / individual_points_for_reviewer(id)
    end
  end

  def strictness_adjusted_points
    ->(rating) { (rating.points * strictness_per_reviewer[rating.user_id]).to_f }
  end

  def individual_points_for_reviewer(id)
    ratings.select{|r| r.user_id == id}.sum(&:points)
  end

end
