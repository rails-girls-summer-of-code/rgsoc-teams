class RemoveProjectNameFromTeams < ActiveRecord::Migration[5.1]
  def up
    migrate_project_name_to_project_id
    remove_column :teams, :project_name, :string
  end

  def down
    add_column :teams, :project_name, :string
    migrate_project_id_to_project_name
  end

  private

  def migrate_project_name_to_project_id
    execute <<~SQL
      UPDATE teams
      SET project_id = projects.id
      FROM projects
      WHERE teams.project_name IS NOT NULL
      AND projects.name = teams.project_name
      AND teams.season_id = projects.season_id
    SQL
  end

  def migrate_project_id_to_project_name
    execute <<~SQL
      UPDATE teams
      SET project_name = projects.name
      FROM projects
      WHERE teams.project_id IS NOT NULL
      AND projects.id = teams.project_id
      AND teams.season_id = projects.season_id
    SQL
  end
end
