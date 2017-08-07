class ConferencePreference < ActiveRecord::Base
  validates :terms, acceptance: true
  attr_accessor :terms_of_ticket, :terms_of_travel

  belongs_to :team, inverse_of: :conference_preference
  belongs_to :first_conference, class_name: 'Conference'
  belongs_to :second_conference, class_name: 'Conference'

  private

    def terms
      conference = first_conference_id.present? || second_conference_id.present?
      terms_checkbox = terms_of_ticket == '1' && terms_of_travel == '1'
      first_case = conference.present? && terms_checkbox.present?
      second_case = conference.blank? && terms_checkbox.blank?
      first_case || second_case
    end
end