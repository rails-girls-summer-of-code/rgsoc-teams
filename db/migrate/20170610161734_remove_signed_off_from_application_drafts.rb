class RemoveSignedOffFromApplicationDrafts < ActiveRecord::Migration[5.1]
  def change
    remove_index :application_drafts, :deprecated_signed_off_by
    remove_column :application_drafts, :deprecated_signed_off_at, :datetime
    remove_column :application_drafts, :deprecated_signed_off_by, :integer
  end
end
