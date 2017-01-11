class AddLatLngToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :application_location_lat, :float
    add_column :users, :application_location_lng, :float
  end
end
