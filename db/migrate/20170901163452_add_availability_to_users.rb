class AddAvailabilityToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :availability, :boolean
  end
end
