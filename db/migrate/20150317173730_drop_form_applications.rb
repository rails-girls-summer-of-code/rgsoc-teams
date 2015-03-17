class DropFormApplications < ActiveRecord::Migration
  def up
    drop_table :form_applications
  end

  def down
    create_table "form_applications", force: true do |t|
      t.string   "name"
      t.string   "email"
      t.text     "about_student"
      t.text     "location"
      t.text     "attended_rg_workshop"
      t.text     "coding_level"
      t.text     "skills"
      t.text     "learning_summary"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "project_name"
      t.hstore   "application_data"
      t.boolean  "submitted"
    end
  end
end
