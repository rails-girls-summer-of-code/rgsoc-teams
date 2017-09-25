class AddColumnOthersInterestIntoUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :other_interest, :string
  end

  def down
    remove_column :users, :other_interest
  end
end
