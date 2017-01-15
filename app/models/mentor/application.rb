class Mentor::Application
  include ActiveModel::Model

  DB = ActiveRecord::Base.connection

  attr_accessor :id
  attr_accessor :team_name
  attr_accessor :project_id, :project_name
  attr_accessor :project_plan, :why_selected_project
  attr_accessor :first_choice

  class << self
    def all_for(project_ids:, choice: 1)
      params = attrs_for(choice: choice).merge(project_ids: project_ids)
      query  = [sql_statement, params]
      DB.select_all(sanitize_sql(query)).map(&mentorize)
    end

    private

    def attrs_for(choice:)
      {
        project_id:           "project#{choice}_id",
        project_plan:         "project#{choice}_plan",
        why_selected_project: "why_selected_project#{choice}",
      }
    end

    def sql_statement
      @sql_statement ||=
      <<-SQL
        SELECT
        applications.id AS id,
        teams.name AS team_name,
        projects.name AS project_name,
        application_data -> :project_id AS project_id,
        application_data -> :project_plan AS project_plan,
        application_data -> :why_selected_project AS why_selected_project,
        CASE WHEN :project_id::text = 'project1_id' THEN TRUE ELSE FALSE END AS first_choice
        FROM applications
        INNER JOIN teams
        ON teams.id = applications.team_id
        INNER JOIN projects
        ON projects.id::text = applications.application_data -> :project_id
        WHERE application_data -> :project_id IN (:project_ids::text);
      SQL
    end

    def sanitize_sql(query)
      ActiveRecord::Base.send(:sanitize_sql_array, query)
    end

    def mentorize
      @mentorize ||= proc { |attrs| self.new(attrs) }
    end
  end
end
