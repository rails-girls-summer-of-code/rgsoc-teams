class RemoveSignedOffFromApplications < ActiveRecord::Migration[5.1]
  def change
    remove_index :applications, :deprecated_signed_off_by
    remove_column :applications, :deprecated_signed_off_at, :datetime
    remove_column :applications, :deprecated_signed_off_by, :integer
  end
end
