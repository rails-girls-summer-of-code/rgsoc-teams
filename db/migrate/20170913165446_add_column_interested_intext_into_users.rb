class AddColumnInterestedIntextIntoUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :other_interests, :string
  end

  def down
    remove_column :users, :other_interests
  end
end
