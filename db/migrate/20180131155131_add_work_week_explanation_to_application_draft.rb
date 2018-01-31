class AddWorkWeekExplanationToApplicationDraft < ActiveRecord::Migration[5.1]
  def change
    add_column :application_drafts, :work_week_explanation, :text
  end
end
