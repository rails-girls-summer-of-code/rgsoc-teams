class DeprecateApplicationDraftSignoff < ActiveRecord::Migration[5.0]
  def change
    rename_column :application_drafts, :signed_off_at, :deprecated_signed_off_at
    rename_column :application_drafts, :signed_off_by, :deprecated_signed_off_by
  end
end
