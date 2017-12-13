class CleanupConferences < ActiveRecord::Migration[5.1]
  def change
    remove_column :conferences, :round, :integer
    remove_column :conferences, :accomodation, :integer
    remove_column :conferences, :flights, :integer
  end
end
