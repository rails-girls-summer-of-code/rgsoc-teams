class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string, :default => nil
  end
end
