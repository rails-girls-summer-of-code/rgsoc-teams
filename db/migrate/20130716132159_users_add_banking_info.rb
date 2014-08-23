class UsersAddBankingInfo < ActiveRecord::Migration
  def change
    add_column :users, :banking_info, :text
  end
end
