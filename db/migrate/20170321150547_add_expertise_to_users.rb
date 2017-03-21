class AddExpertiseToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :Expertise, :string
  end
end
