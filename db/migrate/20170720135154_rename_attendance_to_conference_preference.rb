
class RenameAttendanceToConferencePreference < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :attendances, :conference_preferences
  end

  def self.down
    rename_table :conference_preferences, :attendances
  end
end
