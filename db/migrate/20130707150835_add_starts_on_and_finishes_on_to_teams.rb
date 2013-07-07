class AddStartsOnAndFinishesOnToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :starts_on, :date
    add_column :teams, :finishes_on, :date
  end
end
