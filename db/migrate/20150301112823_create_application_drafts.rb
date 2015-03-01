class CreateApplicationDrafts < ActiveRecord::Migration
  def change
    create_table :application_drafts do |t|
      t.text :coaches_contact_info
      t.text :coaches_hours_per_coach
      t.text :coaches_why_team_successful

      t.text :projects
      t.text :misc_info

      t.string   :signed_off_by
      t.datetime :signed_off_at

      t.belongs_to :team
      t.belongs_to :season

      t.timestamps
    end

    add_index :application_drafts, :season_id
    add_index :application_drafts, :team_id
  end
end
