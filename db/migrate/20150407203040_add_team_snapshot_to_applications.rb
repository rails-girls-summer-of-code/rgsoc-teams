class AddTeamSnapshotToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :team_snapshot, :json
  end
end
