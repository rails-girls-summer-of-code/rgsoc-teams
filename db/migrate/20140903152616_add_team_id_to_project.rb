class AddTeamIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :team_id, :integer
  end
end
