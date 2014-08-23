class TeamsAddTwitterHandle < ActiveRecord::Migration
  def change
    add_column :teams, :twitter_handle, :string
  end
end
