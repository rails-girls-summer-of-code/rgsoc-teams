class AddProjectPlanToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :project_plan, :text
  end
end
