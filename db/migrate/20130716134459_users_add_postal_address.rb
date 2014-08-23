class UsersAddPostalAddress < ActiveRecord::Migration
  def change
    add_column :users, :postal_address, :text
  end
end
