class AddApplicationsCountToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :applications_count, :integer, null: false, default: 0
    add_index :teams, :applications_count

    Team.find_each do |team|
      Team.reset_counters team.id, :applications
    end
  end

  def down
    remove_column :teams, :applications_count
  end
end
