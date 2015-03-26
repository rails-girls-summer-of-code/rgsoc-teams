class AddInvisibleToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :invisible, :boolean, default: false
  end
end
