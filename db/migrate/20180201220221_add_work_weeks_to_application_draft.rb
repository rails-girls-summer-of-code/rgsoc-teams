class AddWorkWeeksToApplicationDraft < ActiveRecord::Migration[5.1]
  def change
    add_column :application_drafts, :work_weeks, :string, array: true, default: []
  end
end
