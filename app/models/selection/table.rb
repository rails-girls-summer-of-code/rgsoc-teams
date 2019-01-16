# frozen_string_literal: true

module Selection
  class Table
    DEFAULT_OPTS = { hide_flags: [] }
    FLAGS        = %i(remote_team
                      male_gender
                      selected
                      zero_community
                      age_below_18
                      less_than_two_coaches).freeze

    def initialize(applications:, options: {})
      @options      = DEFAULT_OPTS.merge(options)
      @applications = applications
        .to_a
        .delete_if { |a| hide?(a) }
        .sort(&sort_order)
    end

    attr_reader :applications

    private

    attr_reader :options

    def sort_order
      case options[:order]
      when :team_name
        ->(a, b) { a.team_name <=> b.team_name }
      when :total_likes
        ->(a, b) { b.total_likes <=> a.total_likes }
      when :total_picks
        ->(a, b) { b.total_picks <=> a.total_picks }
      when :average_points
        ->(a, b) { b.average_points <=> a.average_points }
      when :median_points
        ->(a, b) { b.median_points <=> a.median_points }
      else
        ->(a, b) { a.id <=> b.id }
      end
    end

    def hide?(application)
      (options[:hide_flags].map(&:to_s) & application.flags).any?
    end
  end
end
