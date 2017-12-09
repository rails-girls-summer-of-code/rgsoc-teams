# frozen_string_literal: true
class Table
  class Row
    attr_reader :table, :cells

    def initialize(table, cells)
      @table = table
      @cells = cells
    end

    def to_s(delim = '|')
      "#{delim} #{cells.each_with_index.map { |cell, ix| cell.to_s.ljust(table.width(ix)) }.join(" #{delim} ")} #{delim}"
    end
  end

  attr_reader :rows, :options

  def initialize(rows, options)
    @rows = rows
    @options = options
    @rows = [options[:headers]] + @rows if options[:headers]
  end

  def width(col)
    rows.map { |row| row[col].to_s.length }.max
  end

  def lines
    lines = [separator] + rows.map { |row| format_row(row) } + [separator]
    lines.insert(2, separator) if options[:headers]
    lines = lines.map { |line| ' ' * options[:indent] + line } if options[:indent]
    lines
  end

  def to_s
    lines.join("\n")
  end

  private

  def format_row(row)
    Row.new(self, row).to_s
  end

  def separator
    Row.new(self, rows.first.each_with_index.map { |cell, ix| '-' * width(ix) }).to_s('+')
  end
end
