# frozen_string_literal: true

module DevUtils
  class SeasonPhaseSwitcher
    PHASES = %i(
      fake_proposals_phase
      fake_application_phase
      fake_coding_phase
      back_to_reality
    ).freeze

    class << self
      def destined(phase)
        raise ArgumentError, "#{phase} is not a valid phase" unless phase.in? PHASES
        send(phase)
      end

      private

      def season
        Season.current
      end

      def fake_coding_phase
        season.update(
          starts_at: 6.weeks.ago,
          ends_at: 6.weeks.from_now,
          applications_open_at: 4.months.ago,
          applications_close_at: 3.months.ago,
          acceptance_notification_at: 2.months.ago
        )
      end

      def fake_proposals_phase
        season.update(
          starts_at: 6.months.from_now,
          ends_at: 9.months.from_now,
          applications_open_at: 3.months.from_now,
          applications_close_at: 4.months.from_now,
          acceptance_notification_at: 5.months.from_now,
          project_proposals_open_at: 4.weeks.ago,
          project_proposals_close_at: 4.weeks.from_now
        )
      end

      def fake_application_phase
        season.update(
          starts_at: 2.months.from_now,
          ends_at: 5.months.from_now,
          applications_open_at: 2.weeks.ago,
          applications_close_at: 2.weeks.from_now,
          acceptance_notification_at: 6.weeks.from_now
        )
      end

      def back_to_reality
        this_year = Date.today.year
        season.update(
          name: this_year,
          starts_at: Time.utc(this_year, *Season::SUMMER_OPEN),
          ends_at: Time.utc(this_year, *Season::SUMMER_CLOSE),
          applications_open_at: Time.utc(this_year, *Season::APPL_OPEN),
          applications_close_at: Time.utc(this_year, *Season::APPL_CLOSE),
          acceptance_notification_at: Time.utc(this_year, *Season::APPL_LETTER),
          project_proposals_open_at: Time.utc(this_year - 1, *Season::PROJECTS_OPEN),
          project_proposals_close_at: Time.utc(this_year, *Season::PROJECTS_CLOSE)
        )
      end
    end
  end
end
