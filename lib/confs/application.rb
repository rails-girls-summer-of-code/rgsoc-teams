class Application
  attr_reader :team, :name, :conf
  attr_accessor :flight

  def initialize(team, name, conf)
    @team = team
    @name = name
    @conf = conf
  end

  def to_row
    ["#{conf.name}#{ ' *' if flight}", name, team]
  end
end
