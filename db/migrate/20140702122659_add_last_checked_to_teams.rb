class AddLastCheckedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :last_checked_at, :date
    add_column :teams, :last_checked_by, :integer
  end
end
