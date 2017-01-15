class Mentor::Application < ActiveRecord::Base
  self.table_name = 'applications'

  attribute :id,                   :integer
  attribute :team_name,            :string
  attribute :project_name,         :string
  attribute :project_id,           :integer
  attribute :project_plan,         :text
  attribute :why_selected_project, :text
  attribute :first_choice,         :boolean, default: false

  def self.all_for(projects:) # this works
    self.first_choice_new(projects) + self.second_choice_new(projects)
  end

  def self.first_choice_new(projects) # this works
    joins("INNER JOIN teams ON teams.id = applications.team_id")
    .joins("INNER JOIN projects ON projects.id::text = applications.application_data -> 'project1_id'")
    .select(
      "applications.id,
       teams.name AS team_name,
       projects.name AS project_name,
       application_data -> 'project1_id' AS project_id,
       application_data -> 'project1_plan' AS project_plan,
       application_data -> 'why_selected_project1' AS why_selected_project,
       CASE WHEN NUll = NULL THEN TRUE END AS first_choice")
    .where(
      "application_data -> 'project1_id' IN (:projects)",
      projects: projects.ids.map(&:to_s)
    )
  end

  def self.second_choice_new(projects) # this works
    joins("INNER JOIN teams ON teams.id = applications.team_id")
    .joins("INNER JOIN projects ON projects.id::text = applications.application_data -> 'project2_id'")
    .select(
      "applications.id,
       teams.name AS team_name,
       projects.name AS project_name,
       application_data -> 'project2_id' AS project_id,
       application_data -> 'project2_plan' AS project_plan,
       application_data -> 'why_selected_project2' AS why_selected_project,
       CASE WHEN NULL = NULL THEN FALSE END AS first_choice")
    .where(
      "application_data -> 'project2_id' IN (:projects)",
      projects: projects.ids.map(&:to_s)
    )
  end
end
