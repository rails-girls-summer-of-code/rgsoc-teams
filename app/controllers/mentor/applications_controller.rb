class Mentor::ApplicationsController < Mentor::BaseController
  def index
    @applications = Mentor::Application.all_for(projects: projects)
    # @applications = first_choice
  end

  def show

  end

  private

  def projects
    Project.where(submitter: current_user)
  end

  def first_choice
    Application
      .joins("INNER JOIN teams ON teams.id = applications.team_id")
      .joins("INNER JOIN projects ON projects.id::text = applications.application_data -> 'project1_id'")
      .select(
        "applications.id,
         teams.name AS _team_name,
         projects.name AS _project_name,
         application_data -> 'project1_id' AS _project_id,
         application_data -> 'project1_plan' AS _project_plan,
         application_data -> 'why_selected_project1' AS why_selected_project,
         CASE WHEN EXISTS(SELECT 1) THEN 'True' ELSE 'False' END AS _first_choice")
      .where(
        "application_data -> 'project1_id' IN (:projects)",
        projects: projects.ids.map(&:to_s)
      )
  end

  def applications
    # this would be the query for show...
    # Application.select(
    #   "id,
    #    application_data -> 'project1_id' AS project_id,
    #    application_data -> 'project1_plan' AS project_plan,
    #    application_data -> 'why_selected_project1' AS why_selected_project,
    #    CASE WHEN application_data -> 'project1_id' IN (#{*these_projects}) THEN 'True' ELSE 'False' END AS choice"
    #   ).where(
    #     "application_data -> 'project1_id' IN (:projects)",
    #     projects: projects.ids.map(&:to_s)
    #   )
    # SuperApplication.select("id AS , application_data AS stuff")
    # .where(
    #   "(application_data -> 'project1_id' IN (:projects))
    #    OR
    #    (application_data -> 'project2_id' IN (:projects))",
    #   projects: projects.ids.map(&:to_s)
    # )
    # Application.where(
    #   "(application_data -> 'project1_id' IN (:projects))
    #    OR
    #    (application_data -> 'project2_id' IN (:projects))",
    #   projects: projects.ids.map(&:to_s)
    # )
    # Application.select(
    #   "id,
    #   application_data -> 'project1_plan' AS project_plan,
    #   application_data -> 'project1_id' AS project_id")
    #   .where(
    #   "(application_data -> 'project1_id' IN (:projects))
    #    OR
    #    (application_data -> 'project2_id' IN (:projects))",
    #   projects: projects.ids.map(&:to_s)
    # )
  end

  # def application
  #   Application.select(
  #     "id,
  #      application_data -> 'project1_id' AS project_id,
  #      application_data -> 'project1_plan' AS project_plan,
  #      application_data -> 'why_selected_project1' AS why_selected_project"
  #     ).where(
  #       "application_data -> 'project1_id' IN (:projects)",
  #       projects: projects.ids.map(&:to_s)
  #     )
  # end
end
