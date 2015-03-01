class CreateApplicationDrafts < ActiveRecord::Migration
  def change
    create_table :application_drafts do |t|
      t.text :coaches_contact_info
      t.text :coaches_hours_per_week
      t.text :coaches_why_team_successful

      t.text :project_name
      t.text :project_url

      t.text :misc_info
      t.text :heard_about_it

      t.string   :signed_off_by
      t.datetime :signed_off_at

      t.belongs_to :team
      t.belongs_to :season

      t.boolean :voluntary
      t.integer :voluntary_hours_per_week

      t.timestamps
    end

    add_index :application_drafts, :season_id
    add_index :application_drafts, :team_id
  end
end
