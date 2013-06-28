class Mailing < ActiveRecord::Base
  TO = %w(teams students coaches helpdesk organizers supervisors)

  has_many :submissions, dependent: :destroy

  def submit
    recipient_emails.each { |email| submissions.create!(to: email) }
    update_attributes! sent_at: Time.now
  end

  def recipient_emails
    recipients.map { |recipient| "#{recipient.name} <#{recipient.email}>" }
  end

  def recipients
    recipients = User.includes(:roles).where('roles.name IN (?)', recipient_roles)
    recipients.select { |recipient| recipient.email.present? }
  end

  def recipient_roles
    to == 'teams' ? %w(student coach) : [to.singularize]
  end
end
