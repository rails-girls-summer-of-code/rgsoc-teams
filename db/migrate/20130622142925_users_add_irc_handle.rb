class UsersAddIrcHandle < ActiveRecord::Migration
  def change
    add_column :users, :irc_handle, :string
  end
end
