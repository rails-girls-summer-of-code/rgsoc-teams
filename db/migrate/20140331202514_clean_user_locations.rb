class CleanUserLocations < ActiveRecord::Migration
  def change
    User.where("location = ?", '').update_all(location: nil)
  end
end
