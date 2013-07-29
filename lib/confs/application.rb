class Application
  class << self
  end

  attr_reader :team, :name, :conf

  def initialize(team, name, conf)
    @team = team
    @name = name
    @conf = conf.downcase
  end
end
