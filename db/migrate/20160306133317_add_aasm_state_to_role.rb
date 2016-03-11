class AddAasmStateToRole < ActiveRecord::Migration
  def up
    add_column :roles, :state, :text, :default => 'pending', :null => false
  end

  def down
    remove_column :roles, :state
  end
end
