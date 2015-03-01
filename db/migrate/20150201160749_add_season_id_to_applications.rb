class AddSeasonIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :season_id, :integer
    add_index :applications, :season_id
  end
end
