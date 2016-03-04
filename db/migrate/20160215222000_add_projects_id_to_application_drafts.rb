class AddProjectsIdToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :project1_id, :integer
    add_column :application_drafts, :project2_id, :integer
    add_index :application_drafts, :project1_id
    add_index :application_drafts, :project2_id
  end
end
