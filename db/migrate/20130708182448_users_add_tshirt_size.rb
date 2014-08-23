class UsersAddTshirtSize < ActiveRecord::Migration
  def change
    add_column :users, :tshirt_size, :string
  end
end
