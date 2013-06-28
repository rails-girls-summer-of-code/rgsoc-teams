class Mailing < ActiveRecord::Base
  TO = %w(teams students coaches helpdesk organizers supervisors developers)

  has_many :submissions, dependent: :destroy

  def display_recipients
    [to, cc].join(', ')
  end

  def sent?
    submissions.any?
  end

  def submit
    if sent?
      submissions.unsent.each { |submission| submission.enqueue }
    else
      recipient_emails.each { |email| submissions.create!(to: email) }
      update_attributes! sent_at: Time.now
    end
  end

  def recipient_emails
    recipients.map do |recipient|
      recipient.name.present? ? "#{recipient.name} <#{recipient.email}>" : recipient.email
    end
  end

  def recipients
    recipients = User.includes(:roles).where('roles.name IN (?)', recipient_roles)
    recipients.select { |recipient| recipient.email.present? }
  end

  def recipient_roles
    to == 'teams' ? %w(student coach mentor) : [to.singularize]
  end
end
