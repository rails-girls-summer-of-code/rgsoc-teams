class AddIsSelectedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :is_selected, :boolean
  end
end
