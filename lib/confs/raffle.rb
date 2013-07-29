class Raffle
  attr_reader :confs, :apps, :winners, :runs

  def initialize(confs, data)
    @confs = confs
    @apps = Applications.new(confs)
    data.each { |team, data| data.map { |name, confs| confs.map { |conf| apps.add(team, name, conf) } } }
  end

  def run
    @runs = 0
    @winners = []
    while run?
      @runs += 1
      apps.reject_unavailable_confs!
      available_confs.each do |conf|
        pick_team(conf) or pick_student(conf)
      end
    end
    winners
  end

  private

    def run?
      confs.names.any? { |conf| confs.tickets_available?(conf) && runs < 100 }
    end

    def available_confs
      apps.confs_by_times_requested.select { |conf| confs.tickets_available?(conf) }
    end

    def pick_team(conf)
      return unless confs.available_tickets(conf) >= 2
      teams = apps.teams_by_conf(conf)
      teams = teams.reject { |team| team.any? { |app| winner?(app) } }
      if team = teams.shuffle.first
        team.each { |app| win(app) }
      end
    end

    def pick_student(conf)
      apps = self.apps.by_conf(conf)
      apps = apps.reject { |app| winner?(app) }
      if app = apps.shuffle.first
        win(app)
      end
    end

    def any_winners?(apps)

    end

    def winner?(app)
      winners.map(&:name).include?(app.name)
    end

    def win(app)
      apps.remove(app)
      winners << app
    end

    def try_pick_team_mate(app)
      app = find_pick_team_mate(app)
      win(app) if app
    end

    def find_pick_team_mate(app)
      apps.by_conf_and_team_mate(app.conf, app.team, app.name).first
    end
end


