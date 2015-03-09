class AddMotivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :application_motivation, :text
  end
end
