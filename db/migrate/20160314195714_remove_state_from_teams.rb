class RemoveStateFromTeams < ActiveRecord::Migration
  def up
    remove_column :teams, :state
  end

  def down
    add_column :teams, :state, :text, :default => 'pending', :null => false
  end
end
