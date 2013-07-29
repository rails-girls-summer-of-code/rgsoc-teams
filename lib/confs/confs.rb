class Confs
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def names
    @data.keys
  end

  def tickets_available?(conf)
    available_tickets(conf) > 0
  end

  def available_tickets(conf)
    @data.fetch(conf, {})[:tickets]
  end

  def attend(app)
    @data[app.conf][:tickets] -= 1
  end
end
