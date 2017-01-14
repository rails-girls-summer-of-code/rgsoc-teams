class AddProject2FieldsToApplicationDrafts < ActiveRecord::Migration[5.0]
  def change
    change_table :application_drafts do |t|
      t.rename :why_selected_project, :why_selected_project1
      t.rename :project_plan,         :plan_project1
      t.text :why_selected_project2
      t.text :plan_project2
    end
  end
end
