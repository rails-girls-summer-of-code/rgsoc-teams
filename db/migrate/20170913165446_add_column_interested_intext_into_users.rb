class AddColumnInterestedIntextIntoUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :interested_in_other, :string
  end

  def down
    remove_column :users, :interested_in_other
  end
end
