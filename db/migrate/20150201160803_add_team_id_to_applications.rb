class AddTeamIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :team_id, :integer
    add_index :applications, :team_id
  end
end
