class UsersAddTwitterHandle < ActiveRecord::Migration
  def change
    add_column :users, :twitter_handle, :string
  end
end
