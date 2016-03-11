class AddWhyFieldToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :why_selected_project, :text
  end
end
