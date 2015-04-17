class ChangeSignedOffByToIdOnApplicationDrafts < ActiveRecord::Migration
  def up
    remove_column :application_drafts, :signed_off_by
    add_column :application_drafts, :signed_off_by, :integer
    add_index :application_drafts, :signed_off_by
  end

  def down
    remove_column :application_drafts, :signed_off_by
    create_column :application_drafts, :signed_off_by, :string
  end
end
