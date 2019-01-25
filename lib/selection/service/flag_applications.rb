# frozen_string_literal: true

require 'selection/distance'

module Selection
  module Service
    class FlagApplications
      FLAGS           = %w(remote_team male_gender age_below_18 less_than_two_coaches)
      STUDENT0_COORDS = %w(student0_application_location_lat student0_application_location_lng)
      STUDENT1_COORDS = %w(student1_application_location_lat student1_application_location_lng)
      CITY_THRESH     = 60
      GENDER_FIELDS   = %w(student0_application_gender_identification student1_application_gender_identification)
      MALE_MATCHER    = ->(a) { a =~ /\A\s*(male|man|men|guy)\s*\z/i }
      AGE_FIELDS      = %w(student0_application_age student1_application_age)
      UNDER18         = "under 18"

      def initialize(season: Season.current)
        @season = season
      end

      def call
        applications.find_each do |application|
          @current = application
          @data    = application.application_data
          flags    = compute_flags
          application.update(flags: application.flags | flags) unless flags.empty?
        end
      end

      private

      attr_reader :season, :current, :data

      def applications
        Application
          .includes(team: [:coaches])
          .where(season: season)
          .where.not(team: nil)
      end

      def compute_flags
        FLAGS.map { |flag| flag if send(flag) }.compact
      end

      # Checks if the distance between the students' locations.
      # Skip checking if the data for one of them is missing.
      def remote_team
        location0 = data.values_at(*STUDENT0_COORDS).compact
        location1 = data.values_at(*STUDENT1_COORDS).compact
        Distance.new(location0, location1).to_km > CITY_THRESH
      rescue NoMethodError, TypeError
        false
      end

      def male_gender
        data.values_at(*GENDER_FIELDS).any?(&MALE_MATCHER)
      end

      def age_below_18
        data.values_at(*AGE_FIELDS).include?(UNDER18)
      end

      def less_than_two_coaches
        current.team.coaches.count < 2
      end
    end
  end
end
