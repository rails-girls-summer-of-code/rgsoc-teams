class Application
  class Todo < Struct.new(:user, :subject)
    class TeamNotFound < StandardError
      def initialize(subject)
        super("Could not find team for #{subject.inspect}")
      end
    end

    def next
      detect_next_subject
    rescue TeamNotFound => e
      puts e.message, e.backtrace
    end

    def students
      user_ids = Application.joins(team: :roles).where('roles.name' => :student).pluck(:user_id)
      rated_ids = Rating.where(user: user, rateable_type: 'User').pluck(:rateable_id)
      students = User.where(id: user_ids).order(:id)
      students = students.where('id NOT IN (?)', rated_ids) unless rated_ids.empty?
      students
    end

    def teams
      rated_ids = Rating.where(user: user, rateable_type: 'Team').pluck(:rateable_id)
      team_ids = Application.joins(:team).pluck(:team_id)
      teams = Team.where(id: team_ids)
      teams = teams.where('id NOT IN (?)', rated_ids) unless rated_ids.empty?
      teams
    end

    def applications
      rated_ids = Rating.where(user: user, rateable_type: 'Application').pluck(:rateable_id)
      applications = Application.order(:id)
      applications = applications.where('id NOT IN (?)', rated_ids) unless rated_ids.empty?
      applications
    end

    private

      def detect_next_subject
        case subject
        when nil
          first_student
        when Application
          applications_rated? ? next_teams_first_student : next_team_application(subject.team)
        when Team
          next_team_application
        when User
          other = other_student
          return other if other
          rated?(current_team) ? next_team_application : current_team
        end
      end

      def first_student
        ids = Application.joins(team: :roles).where('roles.name' => :student).pluck(:user_id)
        User.where(id: ids).order(:id).first
      end

      def next_teams_first_student
        rated_ids = Rating.where(user: user, rateable_type: 'Team').pluck(:id)
        team_ids = Application.joins(:team).pluck(:team_id)
        team = Team.where(id: team_ids).where('id > ? AND id NOT IN (?)', subject.team.id, rated_ids).order(:id).first
        team.students.first
      end

      def next_team_application(subject = self.subject)
        subject.applications.detect { |application| !rated?(application) }
      end

      def applications_rated?
        subject.team.applications.all? { |application| rated?(application) }
      end

      def students_rated?
        current_team.students.all? { |student| rated?(student) }
      end

      def rated?(rateable)
        Rating.where(user: user, rateable: rateable).exists?
      end

      def single_student_team?
        current_team.students.size == 1
      end

      def current_team
        @current_team ||= subject.teams.first or raise(TeamNotFound.new(subject))
      end

      def other_student
        other = current_team.students.reject { |student| student.id == subject.id }.first
        other if !rated?(other)
      end
  end
end
