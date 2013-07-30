class Confs
  include Enumerable

  attr_reader :confs

  def initialize(data)
    data = data.map { |name, conf| [name, conf[:tickets], conf[:flights]] }.shuffle
    @confs = data.map { |row| Conf.new(*row) }
  end

  def by_popularity
    confs.sort_by(&:popularity).reverse
  end

  def each(&block)
    confs.each(&block)
  end

  def [](name)
    confs.detect { |conf| conf.name == name.downcase }
  end
end
