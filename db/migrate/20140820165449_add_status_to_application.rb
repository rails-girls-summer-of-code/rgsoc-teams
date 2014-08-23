class AddStatusToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :status, :string
  end
end
