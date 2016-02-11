class RemoveCoachFieldsFromApplicationDrafts < ActiveRecord::Migration
  def up
    remove_column :application_drafts, :coaches_why_team_successful
    remove_column :application_drafts, :coaches_hours_per_week
  end

  def down
    add_column :application_drafts, :coaches_why_team_successful, :text
    add_column :application_drafts, :coaches_hours_per_week, :text
  end
end
