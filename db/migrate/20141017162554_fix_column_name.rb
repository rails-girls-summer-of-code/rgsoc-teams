class FixColumnName < ActiveRecord::Migration
  def change
    change_table :form_applications  do |t|
      t.rename :project, :project_name
      t.rename :about, :about_student
      t.rename :attended_rg_ws, :attended_rg_workshop

    end
  end
end
