class RenameAttendanceToConferencePreference < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :attendances, :conferencePreferences
  end

  def self.down
    rename_table :conferencePreferences, :attendances
  end
end
