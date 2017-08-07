class CreateConferenceAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :conference_attendances do |t|
      t.boolean :attendance
      t.text :orga_comment
      t.references :team, foreign_key: true
      t.references :conference, foreign_key: true

      t.timestamps
    end
  end
end
