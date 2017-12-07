class AddDefaultValueToAvailability < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :availability, false
  end
end
