# frozen_string_literal: true

class Mailing < ApplicationRecord
  TO = %w(teams students coaches helpdesk organizers supervisors developers mentors)
  FROM = ENV['EMAIL_FROM'] || 'contact@rgsoc.org'

  has_many :submissions, dependent: :destroy

  validates :subject, :to, presence: true

  serialize :to
  enum group: { everyone: 0, selected_teams: 1, unselected_teams: 2 }
  delegate :emails, to: :recipients

  def sent?
    submissions.any?
  end

  def submit
    if sent?
      submissions.unsent.each { |submission| submission.enqueue }
    else
      emails.each { |email| submissions.create!(to: email) }
      update_attributes! sent_at: Time.now.utc
      Activity.create!(kind: 'mailing', guid: id, author: from, title: subject, content: body, published_at: sent_at)
    end
  end

  def recipients
    @recipients ||= Recipients.new(self)
  end

  def recipient?(user)
    recipients.users.include? user
  end

  def seasons=(value)
    options = Season.pluck(:name)
    self[:seasons] = value.select { |s| options.include?(s) }
  end
end
