class CreateFormApplications < ActiveRecord::Migration
  def change
    create_table :form_applications do |t|
      t.string :name
      t.string :email
      t.text :about
      t.text :location
      t.text :attended_rg_ws
      t.text :coding_level
      t.text :skills
      t.text :learning_summary

      t.timestamps
    end
  end
end
