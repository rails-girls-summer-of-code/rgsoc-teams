class AddSignedOffByToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :signed_off_by, :integer
    add_index :applications, :signed_off_by
  end
end
