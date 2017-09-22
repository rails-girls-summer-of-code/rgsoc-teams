class ConferencePreference < ActiveRecord::Base
  validates :terms_of_ticket, inclusion: { in: [true] }, if: :conference_exists?
  validates :terms_of_travel, inclusion: { in: [true] }, if: :conference_exists?
  before_save :change_status_terms, unless: :conference_exists?

  belongs_to :team, inverse_of: :conference_preference
  belongs_to :first_conference, class_name: 'Conference'
  belongs_to :second_conference, class_name: 'Conference'

  scope :current_teams, -> {
    joins(:team).where(teams: { season_id: Season.current.id })
  }

  def has_preference?
    first_conference.present? || second_conference.present?
  end

  def terms_accepted?
    terms_of_travel && terms_of_ticket
  end

  private

  def conference_exists?
    first_conference_id.present? || second_conference_id.present?
  end

  def change_status_terms
    self.terms_of_travel = false
    self.terms_of_ticket = false
  end
end
