class Confs
  include Enumerable

  attr_reader :data, :confs

  def initialize(data)
    @data = data
    @confs = data.map { |name, conf| Conf.new(name, conf[:tickets], conf[:flights]) }
  end

  def each(&block)
    confs.each(&block)
  end

  def [](name)
    confs.detect { |conf| conf.name == name.downcase }
  end
end
