class RemoveBankingInfoFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :banking_info, :text
  end
end
