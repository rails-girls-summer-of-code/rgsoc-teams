class Applications
  attr_reader :apps

  def initialize
    @apps = []
  end

  def add(team, name, conf)
    app = Application.new(team, name, conf)
    apps << app
    count(app)
    app
  end

  def remove(app)
    apps.delete(app)
  end

  def reject_unavailable_confs!
    apps.select! { |app| app.conf.tickets? }
  end

  def counts
    @counts ||= {}
  end

  def confs_by_times_requested
    apps_by_times_requested.map(&:conf).uniq
  end

  def by_conf(name)
    apps.select { |app| app.conf.name == name }
  end

  def by_conf_and_team_mate(conf, team, name)
    apps.select { |app| app.conf.name == conf && app.team == team && app.name != name }
  end

  def teams_by_conf(name)
    teams = by_conf(name).inject({}) do |teams, app|
      teams[app.team] ||= []
      teams[app.team] << app
      teams
    end
    teams.values.select { |apps| apps.length == 2 }
  end

  private

    def count(app)
      counts[app.conf] ||= 0
      counts[app.conf] += 1
    end

    def apps_by_times_requested
      apps.sort { |lft, rgt| counts[rgt.conf] <=> counts[lft.conf] }
    end
end


