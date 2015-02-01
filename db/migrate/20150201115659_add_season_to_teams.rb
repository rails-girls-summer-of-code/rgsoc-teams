class AddSeasonToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :season_id, :integer
    add_index :teams, :season_id
  end
end
