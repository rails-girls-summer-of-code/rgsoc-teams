class Recipients
  delegate :group, :to, :cc, :bcc, to: :mailing

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
    case group.to_sym
    when :selected_teams
      User.joins(:teams, :roles)
        .where(teams: { kind: Team::KINDS }, roles: { name: roles }).uniq
    when :unselected_teams
      User.joins(:teams, :roles)
        .where(teams: { kind: nil }, roles: { name: roles }).uniq
    else
      User.joins(:roles).where(roles: { name: roles }).uniq
    end
  end

  def roles
    Array(to).map do |to|
      to == 'teams' ? %w(student coach mentor) : [to.singularize]
    end.flatten
  end
end
