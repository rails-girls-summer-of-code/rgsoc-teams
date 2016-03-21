class ChangeApplicationMoneyToString < ActiveRecord::Migration
  def change
    change_column :users, :application_money, :string
  end
end
