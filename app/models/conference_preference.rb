class ConferencePreference < ActiveRecord::Base
  validates :terms_checked?, acceptance: true
  attr_accessor :terms_of_ticket, :terms_of_travel

  belongs_to :team, inverse_of: :conference_preference
  belongs_to :first_conference, class_name: 'Conference'
  belongs_to :second_conference, class_name: 'Conference'

  private

  def terms_checked?
    conference_chosen = first_conference_id.present? || second_conference_id.present?
    terms_checked = terms_of_ticket == '1' && terms_of_travel == '1'
    (conference_chosen && terms_checked) || (!conference_chosen && !terms_checked)
  end
end