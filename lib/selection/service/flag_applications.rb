module Selection
  module Service
    class FlagApplications
      FLAGS           = %w(remote_team male_gender age_below_18 less_than_two_coaches)
      LOCATION_FIELDS = %w(student0_application_location student1_application_location)
      CITY_MATCHER    = ->(location) { location.downcase.scan(/\w+/).values_at(0, -1) }
      GENDER_FIELDS   = %w(student0_application_gender_identification student1_application_gender_identification)
      MALE_MATCHER    = ->(a) { a =~ /\A\s*male\z|\A\s*man\z|\A\s*men\z|\A\s*guy\z/i }
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

      def remote_team
        data.values_at(*LOCATION_FIELDS).uniq(&CITY_MATCHER).size > 1
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
