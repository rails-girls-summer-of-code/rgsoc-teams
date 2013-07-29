class Applications
  attr_reader :apps, :confs

  def initialize(confs)
    @apps = []
    @confs = confs
  end

  def add(team, name, conf)
    app = Application.new(team, name, conf)
    apps << app
    count(app)
    app
  end

  def remove(app)
    confs.attend(app)
    apps.delete(app)
  end

  def reject_unavailable_confs!
    apps.select! { |app| confs.tickets_available?(app.conf) }
  end


  def counts
    @counts ||= {}
  end

  def confs_by_times_requested
    apps_by_times_requested.map { |app| app.conf }.uniq
  end

  def by_conf(conf)
    apps.select { |app| app.conf == conf }
  end

  def by_conf_and_team_mate(conf, team, name)
    apps.select { |app| app.conf == conf && app.team == team && app.name != name }
  end

  def teams_by_conf(conf)
    teams = by_conf(conf).inject({}) { |teams, app| (teams[app.team] ||= []) << app; teams }
    teams.values.select { |apps| apps.length == 2 }
  end

  private

    def count(app)
      counts[app.conf] ||= 0
      counts[app.conf] += 1
    end

    def apps_by_times_requested
      apps.sort { |lft, rgt| counts[lft.conf] <=> counts[rgt.conf] }.reverse
    end
end


