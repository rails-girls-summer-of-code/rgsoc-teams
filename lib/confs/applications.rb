# frozen_string_literal: true
class Applications
  attr_reader :apps

  def initialize
    @apps = []
  end

  def add(team, name, conf)
    apps << Application.new(team, name, conf)
  end

  def remove(app)
    apps.delete(app)
  end

  def reject_unavailable_confs!
    apps.select! { |app| app.conf.tickets? }
  end

  def select_by(attrs)
    apps.select { |app| attrs.all? { |name, value| app.send(name) == value } }
  end

  def select_teams_by(attrs)
    teams = select_by(attrs).group_by(&:team)
    teams.values.select { |apps| apps.length == 2 }
  end
end
