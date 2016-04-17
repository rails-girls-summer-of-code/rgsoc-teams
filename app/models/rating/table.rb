require 'forwardable'

class Rating::Table
  class Row
    extend Forwardable

    def_delegators :application, :id, :flags, :location, :team_name,
      :project_name, :student_name, :total_picks, :average_points

    attr_reader :names, :application, :options

    # TODO: pass users, not just names
    def initialize(names, application, options)
      @names = names
      @application = application
      @options = default_options.merge options
    end

    def default_options
      { hide_flags: [] }
    end

    def ratings
      @ratings ||= names.map do |name|
        ratings = application.ratings
        ratings = ratings.excluding(options[:exclude]) unless options[:exclude].blank?
        rating = ratings.find { |rating| rating.user.name == name }
        rating || Hashr.new(value: '-')
      end
    end

    def display?
      (options[:hide_flags] & flags).empty?
    end
  end

  attr_reader :names, :rows, :order, :options

  def initialize(names, applications, options)
    @names = names # should be users / reviewers
    @options = options
    @rows = applications.map { |application| Row.new(names, application, options) }
    @rows = rows.select { |row| row.display? }
    @rows = sort(rows)
  end

  def sort(rows)
    case order = options[:order].try(:to_sym)
    when :picks
      sort_by_picks(rows).reverse
    when :average_points
      rows.sort_by { |row| row.average_points }.reverse
    else
      rows.select(&order).sort_by(&order) + rows.reject(&order)
    end
  end

  def sort_by_picks(rows)
    rows.sort do |lft, rgt|
      if lft.total_picks == rgt.total_picks
        result = lft.average_points <=> rgt.average_points
        result
      else
        lft.total_picks <=> rgt.total_picks
      end
    end
  end
end
