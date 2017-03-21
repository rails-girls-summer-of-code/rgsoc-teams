class AddInterestsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :Interests, :string
  end
end
