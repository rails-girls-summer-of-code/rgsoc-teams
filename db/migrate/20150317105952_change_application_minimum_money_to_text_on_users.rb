class ChangeApplicationMinimumMoneyToTextOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :application_minimum_money, :text
  end

  def down
    change_column :users, :application_minimum_money, :string
  end
end
