class AddUpdatedByToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :updater_id, :integer
  end
end
