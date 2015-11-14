class AddProjectNameToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :project_name, :string

    Project.joins(:team).each do |project|
      project.team.update_column :project_name, project.name
    end
  end

  def down
    remove_column :teams, :project_name
  end
end
