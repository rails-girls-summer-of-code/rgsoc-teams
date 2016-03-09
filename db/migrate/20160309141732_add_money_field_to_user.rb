class AddMoneyFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :application_money, :integer
  end
end
