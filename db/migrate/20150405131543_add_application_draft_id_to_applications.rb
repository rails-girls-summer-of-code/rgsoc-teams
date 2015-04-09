class AddApplicationDraftIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :application_draft_id, :integer
    add_index :applications, :application_draft_id
  end
end
