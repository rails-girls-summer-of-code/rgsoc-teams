class UsersAddInterestedIn < ActiveRecord::Migration
  def change
    add_column :users, :interested_in, :string, array: true, default: []
  end
end
