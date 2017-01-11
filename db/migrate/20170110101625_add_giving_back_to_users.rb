class AddGivingBackToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :application_giving_back, :text
  end
end
