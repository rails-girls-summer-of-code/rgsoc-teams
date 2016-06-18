module Exporters
  class Teams < Base

    def current
      teams = Team.where(season: Season.current).includes(:members)

      generate(teams, 'Team ID', 'Name', 'Location', "1st Student's Name", "1st Student's Email", "2nd Student's Name", "2nd Student's Email", "Coaches' Emails") do |t|
        student1 = t.students[0] || Student.new
        student2 = t.students[1] || Student.new
        coaches_emails = t.coaches.map(&:email).reject(&:blank?).join(', ')
        [t.id, t.name, t.students_location, student1.name, student1.email, student2.name, student2.email, coaches_emails]
      end
    end

  end
end
