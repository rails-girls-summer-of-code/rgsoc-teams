class AddReferencesToAttendance < ActiveRecord::Migration[5.1]
  def change
    add_reference :attendances, :team, foreign_key: true
    add_reference :attendances, :conference, foreign_key: true
  end
end
