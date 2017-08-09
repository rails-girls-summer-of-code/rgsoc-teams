class ConferencePreference < ActiveRecord::Base
  validate :terms_checked?
  attr_accessor :terms_of_ticket, :terms_of_travel

  belongs_to :team, inverse_of: :conference_preference
  belongs_to :first_conference, class_name: 'Conference'
  belongs_to :second_conference, class_name: 'Conference'

  def has_preference?
    first_conference.present? || second_conference.present?
  end

  private

  def terms_checked?
    conference_chosen = first_conference_id || second_conference_id
    terms_checked = terms_of_ticket == '1' && terms_of_travel == '1'
    (conference_chosen && terms_checked) || (!conference_chosen && !terms_checked)
  end
end