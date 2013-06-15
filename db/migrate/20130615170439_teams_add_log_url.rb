class TeamsAddLogUrl < ActiveRecord::Migration
  def change
    add_column :teams, :log_url, :string
  end
end
