class RemoveProjectsFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :projects, :string
  end
end
