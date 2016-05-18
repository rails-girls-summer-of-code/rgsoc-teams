class AddSeasonIdToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :season_id, :integer
    add_index :conferences, :season_id
  end
end
