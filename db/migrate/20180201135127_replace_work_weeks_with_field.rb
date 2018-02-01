class ReplaceWorkWeeksWithField < ActiveRecord::Migration[5.1]
  def change
    drop_table :application_draft_work_weeks
    drop_table :work_weeks
    add_column :application_drafts, :work_weeks, :string, array: true, default: []
  end
end
