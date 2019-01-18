# frozen_string_literal: true

module Exporters
  class Teams < Base
    (2015..Date.today.year).each do |year|
      define_method "accepted_#{year}" do
        season = Season.find_by(name: year)
        teams = Team.accepted.where(season: season).includes(:members)
        export(teams)
      end
    end

    def current
      teams = Team.where(season: Season.current).includes(:members)
      export(teams)
    end

    private

    def export(teams)
      generate(teams, 'Team ID', 'Name', 'Location', "1st Student's Name", "1st Student's Email", "2nd Student's Name", "2nd Student's Email", "Coaches' Emails", "Coaches' Names") do |t|
        student1 = t.students[0] || Student.new
        student2 = t.students[1] || Student.new
        coaches_emails = t.coaches.map(&:email).reject(&:blank?).join(', ')
        coaches_names  = t.coaches.map(&:name_or_handle).join(', ')
        [t.id, t.name, t.students_location, student1.name, student1.email, student2.name, student2.email, coaches_emails, coaches_names]
      end
    end
  end
end
