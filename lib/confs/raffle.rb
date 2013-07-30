class Raffle
  attr_reader :confs, :apps, :winners, :runs

  def initialize(confs, data)
    @confs = confs
    @apps = Applications.new

    data.each do |team, data|
      data.map do |name, conf_names|
        conf_names.map do |conf|
          apps.add(team, name, confs[conf])
        end
      end
    end

    confs.sort!
  end

  # Main loop for the raffe. Cleans out unavailable confs from the applications set.
  # Then for each available conf (ordered by popularity, most popular first) it first
  # tries to pick a full team, then tries to pick a student. Force stops after 100 runs.
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
      confs.any? { |confs| confs.tickets? } && runs < 100
    end

    def available_confs
      confs.select { |conf| conf.tickets? }
    end

    # Tries to pick a team for the given conf. If there are at least two
    # tickets available then it tries to find teams who has applied and where
    # none of the student who has won during this raffle already. Then picks
    # one of these teams randomly.
    def pick_team(conf)
      return unless conf.tickets >= 2
      teams = apps.select_teams_by(conf_name: conf.name)
      teams = teams.reject { |team| team.any? { |app| winner?(app) } }
      if team = teams.shuffle.first
        team.each { |app| win(app) }
      end
    end

    # Tries to pick a student for the given conf. If there's at least one
    # ticket avaialbe then it tries to find students who have not won during
    # this raffle already. Then picks one of these students randomly.
    def pick_student(conf)
      return unless conf.tickets?
      apps = self.apps.select_by(conf_name: conf.name)
      apps = apps.reject { |app| winner?(app) }
      if app = apps.shuffle.first
        win(app)
      end
    end

    def winner?(app)
      winners.map(&:name).include?(app.name)
    end

    def win(app)
      apps.remove(app)
      app.conf.attend(app)
      winners << app
    end
end
