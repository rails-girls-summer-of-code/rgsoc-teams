class ConferencePreference < ActiveRecord::Base
  validates :terms_accepted?, acceptance: true

  attr_accessor :terms_of_ticket, :terms_of_travel

  belongs_to :team, inverse_of: :conference_preference
  belongs_to :first_conference, class_name: 'Conference'
  belongs_to :second_conference, class_name: 'Conference'

  private

    def terms_accepted?
      conference = first_conference_id.present? || second_conference_id.present?
      terms_checkbox = terms_of_ticket == '1' && terms_of_travel == '1'
      first_case = conference.present? && terms_checkbox.present?
      second_case = conference.blank? && terms_checkbox.blank?
      errors.add(:team, "You must accept the terms") if conference && !terms_checkbox
      errors.add(:team, "You must choose the conferences") if !conference && terms_checkbox
      first_case || second_case
    end
end