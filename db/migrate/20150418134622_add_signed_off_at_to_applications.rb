class AddSignedOffAtToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :signed_off_at, :datetime
  end
end
