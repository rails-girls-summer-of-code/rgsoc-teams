class AddRoundToConferences < ActiveRecord::Migration
  def up
    add_column :conferences, :round, :integer, default: 1
  end

  def down
    remove_column :conferences, :round, :integer
  end
end
