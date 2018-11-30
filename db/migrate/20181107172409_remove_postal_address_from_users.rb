class RemovePostalAddressFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :postal_address, :text
  end
end
