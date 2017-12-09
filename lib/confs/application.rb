# frozen_string_literal: true
class Application
  attr_reader :team, :name, :conf
  attr_accessor :flight

  def initialize(team, name, conf)
    @team = team
    @name = name
    @conf = conf
    conf.popularity += 1
  end

  def conf_name
    conf.name
  end

  def to_row
    ["#{conf.name}#{ ' *' if flight}", name, team]
  end
end
