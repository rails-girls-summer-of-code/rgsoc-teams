class RenameWorkSchedulesToWorkWeek < ActiveRecord::Migration[5.1]
  def change
    rename_table :work_schedules, :work_weeks
    rename_table :application_draft_work_schedules, :application_draft_work_weeks
    rename_column :application_draft_work_weeks, :work_schedule_id, :work_week_id
  end
end
