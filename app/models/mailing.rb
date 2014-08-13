class Mailing < ActiveRecord::Base
  TO = %w(teams students coaches helpdesk organizers supervisors developers)

  serialize :to

  has_many :submissions, dependent: :destroy

  delegate :emails, to: :recipients

  def sent?
    submissions.any?
  end

  def submit
    if sent?
      submissions.unsent.each { |submission| submission.enqueue }
    else
      emails.each { |email| submissions.create!(to: email) }
      update_attributes! sent_at: Time.now
      Activity.create!(kind: 'mailing', guid: id, author: from, title: subject, content: body, published_at: sent_at)
    end
  end

  def recipients
    @recipients ||= Recipients.new(self)
  end

  def recipient?(user)
    recipients.users.include? user
  end
end
