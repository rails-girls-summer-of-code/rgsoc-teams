module Mentor
  class Application
    include ActiveModel::Model

    DB = ActiveRecord::Base.connection

    attr_accessor :id, :team_name
    attr_accessor :project_id, :project_name
    attr_accessor :project_plan, :why_selected_project
    attr_accessor :student0, :student1
    attr_accessor :first_choice

    def choice
      first_choice ? 1 : 2
    end

    def student0=(attrs)
      attrs     = JSON.parse(attrs).instance_eval(&studentize)
      @student0 = Mentor::Student.new(attrs)
    end

    def student1=(attrs)
      attrs     = JSON.parse(attrs).instance_eval(&studentize)
      @student1 = Mentor::Student.new(attrs)
    end

    def find_or_initialize_comment_by(mentor)
      Mentor::Comment.find_or_initialize_by(
        commentable_id:   id,
        commentable_type: self.class.name,
        user:             mentor)
    end

    private

    def studentize
      @studentize ||= proc do |attrs|
        attrs.tap { |a| a.keys.each{ |k| a[k.gsub(/student(0|1)_application_/, '')] = a.delete(k) } }
      end
    end

    class << self
      def all_for(projects:, choice: 1, season: Season.current)
        params = { project_id: "project#{choice}_id", project_ids: projects.ids, season_id: season.id }
        query  = [sql_statement_all, params]
        DB.select_all(sanitize_sql(query)).map(&mentorize)
      end

      def find(id:, projects:, season: Season.current)
        data = data_for(id: id, choice: 1, projects: projects, season: season) ||
               data_for(id: id, choice: 2, projects: projects, season: season) ||
               fail(ActiveRecord::RecordNotFound)
        data.instance_eval(&mentorize)
      end

      private

      def data_for(id:, projects:, choice:, season:)
        params = attrs_for(choice: choice).merge(id: id, project_ids: projects.ids, season_id: season.id)
        query  = [sql_statement_find, params]
        DB.select_one(sanitize_sql(query))
      end

      def attrs_for(choice:)
        {
          project_id:           "project#{choice}_id",
          project_plan:         "plan_project#{choice}",
          why_selected_project: "why_selected_project#{choice}",
          student0_attrs:       student_attrs(index: 0),
          student1_attrs:       student_attrs(index: 1)
        }
      end

      def student_attrs(index: 0)
        Mentor::Student::APPLICATION_KEYS.map { |key| "student#{index}#{key}" }
      end

      def sql_statement_all
        @sql_statement_all ||=
        <<-SQL
          SELECT
          applications.id AS id,
          teams.name AS team_name,
          projects.name AS project_name,
          (application_data -> :project_id)::int AS project_id,
          CASE WHEN :project_id::text = 'project1_id' THEN TRUE ELSE FALSE END AS first_choice
          FROM applications
          INNER JOIN teams
          ON teams.id = applications.team_id
          INNER JOIN projects
          ON projects.id::text = applications.application_data -> :project_id
          WHERE (application_data -> :project_id)::int IN (:project_ids)
          AND applications.season_id = :season_id;
        SQL
      end

      def sql_statement_find
        @sql_statement_find ||=
        <<-SQL
          SELECT
          applications.id AS id,
          teams.name AS team_name,
          projects.name AS project_name,
          (application_data -> :project_id)::int AS project_id,
          application_data -> :project_plan AS project_plan,
          application_data -> :why_selected_project AS why_selected_project,
          CASE WHEN :project_id::text = 'project1_id' THEN TRUE ELSE FALSE END AS first_choice,
          hstore_to_json_loose(slice(application_data, ARRAY[:student0_attrs])) AS student0,
          hstore_to_json_loose(slice(application_data, ARRAY[:student1_attrs])) AS student1
          FROM applications
          INNER JOIN teams
          ON teams.id = applications.team_id
          INNER JOIN projects
          ON projects.id::text = applications.application_data -> :project_id
          WHERE (application_data -> :project_id)::int IN (:project_ids)
          AND applications.season_id = :season_id
          AND applications.id = :id;
        SQL
      end

      def sanitize_sql(query)
        ActiveRecord::Base.send(:sanitize_sql_array, query)
      end

      def mentorize
        @mentorize ||= proc { |attrs| Mentor::Application.new(attrs) }
      end
    end
  end
end
