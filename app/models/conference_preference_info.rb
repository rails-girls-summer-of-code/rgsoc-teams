class ConferencePreferenceInfo < ApplicationRecord
  belongs_to :team
  has_many :conference_preferences, dependent: :destroy
  accepts_nested_attributes_for :conference_preferences,
                                allow_destroy: true,
                                reject_if: :without_conferences?
  validate :accepted_conditions?

  def with_preferences_build
    team_preferences = []
    team_preferences << conference_preferences.build(option: 1) unless conference_preferences.find_by(option: 1)
    team_preferences << conference_preferences.build(option: 2) unless conference_preferences.find_by(option: 2)
    team_preferences
  end

  def without_conferences?(att)
    att[:conference_id].blank?
  end

  def accepted_conditions?
    return unless conference_preferences.any?  && (!condition_term_ticket || !condition_term_cost)
    errors.add(:team, 'you must accept terms and conditions.')
  end
end
