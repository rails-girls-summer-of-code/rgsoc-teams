# frozen_string_literal: true

module Exporters
  class ConferencePreferences < Base
    def current
      preferences = ConferencePreference.current_teams
      team_max_offer = Team.joins(:conference_attendances).group("teams.id").order("count(teams.id) DESC").first
      max_offer = team_max_offer&.conference_attendances&.size || 0

      header = 'Team name', 'Team location', 'Project name', 'Conference primary choice', 'Conference secondary choice', 'We would like to give a LT', 'Comments', 'Terms accepted'
      max_offer.times do |n|
        header << "Conference Offer #{n + 1}"
        header << "Conference Offer #{n + 1} accepted"
      end

      generate(preferences, *header) do |cp|
        team_preferences = [cp.team&.name, cp.team&.students_location, cp.team&.project_name, cp.first_conference&.name, cp.second_conference&.name, cp.lightning_talk, cp.comment, cp.terms_accepted?]
        cp.team&.conference_attendances&.each do |ca|
          team_preferences << ca.conference.name
          team_preferences << ca.attendance
        end
        team_preferences
      end
    end
  end
end
