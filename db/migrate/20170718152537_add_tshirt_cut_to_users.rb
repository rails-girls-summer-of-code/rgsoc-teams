class AddTshirtCutToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tshirt_cut, :string
  end
end
