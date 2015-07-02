class Recipients
  delegate :seasons, :group, :to, :cc, :bcc, to: :mailing

  attr_reader :mailing

  def initialize(mailing)
    @mailing = mailing
  end

  def emails
    ([cc, bcc] + user_emails).flatten.select(&:present?).map(&:downcase).uniq
  end

  def user_emails
    users.map(&:email)
  end

  def users
    return @users if @users
    @users = User.joins(:teams, :roles).where(roles: { name: roles })
    if group.to_sym == :selected_teams
      @users = @users.where(teams: { kind: Team::KINDS })
    elsif group.to_sym == :unselected_teams
      @users = @users.where(teams: { kind: nil })
    end
    if seasons.any?
      @users = @users.where(teams: {
        season: Season.where(name: seasons).pluck(:id)
      })
    end
    @users.uniq
  end

  def roles
    Array(to).map do |to|
      to == 'teams' ? %w(student coach mentor) : [to.singularize]
    end.flatten
  end
end
