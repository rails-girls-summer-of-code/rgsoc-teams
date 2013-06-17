class AddDescriptionToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :description, :text
  end
end
