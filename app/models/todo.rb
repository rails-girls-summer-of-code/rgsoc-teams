# frozen_string_literal: true

class Todo < ApplicationRecord
  BLACK_FLAGS = %w(remote_team male_gender age_below_18 less_than_two_coaches zero_community)
  SIGN_OFFS   = %w(signed_off_at_project1 signed_off_at_project2)

  belongs_to :user
  belongs_to :application

  delegate :application_data, :season, to: :application

  validate :validate_number_of_reviewers, if: :application

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

  def sign_offs?
    application_data.values_at(*SIGN_OFFS).map(&:present?)
  end

  def validate_number_of_reviewers
    errors.add(:user, :too_many_reviewers) if application.todos.count > 3
  end
end
