class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :application_code_background, :text
    add_column :users, :application_age, :text
    add_column :users, :application_goals, :text
  end
end
