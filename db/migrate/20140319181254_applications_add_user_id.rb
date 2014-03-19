class ApplicationsAddUserId < ActiveRecord::Migration
  def change
    add_column :applications, :user_id, :integer
  end
end
