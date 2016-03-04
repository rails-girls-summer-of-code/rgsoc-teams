class AddAasmStateToTeam < ActiveRecord::Migration
  def up
    add_column :teams, :state, :text, :default => 'pending', :null => false
  end

  def down
    remove_column :teams, :state
  end
end
