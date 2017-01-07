class Attendance < ActiveRecord::Base
  belongs_to :conference
end

class RemoveOrphanedAttendanceRecords < ActiveRecord::Migration[5.0]
  def up
    Attendance.where(conference: nil).destroy_all
  end

  def down
  end
end
