class Confs
  include Enumerable

  attr_reader :confs

  def initialize(data)
    data = data.map { |name, conf| [name, conf[:tickets], conf[:flights]] }.shuffle
    @confs = data.map { |row| Conf.new(*row) }
  end

  def sort!
    @confs = confs.sort do |lft, rgt|
      cmp(:popularity, lft, rgt) || cmp(:tickets, lft, rgt) || 0
    end.reverse
  end

  def each(&block)
    confs.each(&block)
  end

  def [](name)
    confs.detect { |conf| conf.name == name.downcase }
  end

  def total_tickets
    confs.map(&:tickets).inject(&:+)
  end

  private

    def cmp(attr, lft, rgt)
      order = lft.send(attr) <=> rgt.send(attr)
      order unless order == 0
    end
end
