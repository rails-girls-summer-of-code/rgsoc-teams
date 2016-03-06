class AddWorkingTogetherToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :working_together, :text
  end
end
