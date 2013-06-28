class Recipients
  delegate :to, :cc, :bcc, to: :mailing

  attr_reader :mailing

  def initialize(mailing)
    @mailing = mailing
  end

  def emails
    [cc, bcc].select(&:present?) + user_emails
  end

  def user_emails
    users.map { |user| user.name.present? ? "#{user.name} <#{user.email}>" : user.email }
  end

  def users
    User.includes(:roles).where('roles.name IN (?)', roles).select { |u| u.email.present? }
  end

  def roles
    to.map do |to|
      to == 'teams' ? %w(student coach mentor) : [to.singularize]
    end.flatten
  end
end
