module Exporters
  class ConferencePreferences < Base

    def current
      preferences = ConferencePreference.current_teams

      generate(preferences, 'Team name', 'Team location', 'Project name', 'Conference primary choice', 'Conference secondary choice', 'We would like to give a LT', 'Comments', 'Terms accepted') do |cp|
        [cp.team&.name, cp.team&.students_location, cp.team&.project_name, cp.first_conference&.name, cp.second_conference&.name, cp.lightning_talk, cp.comment, cp.terms_accepted?]
      end
    end
  end
end