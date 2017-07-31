class ChangeColumnsFromConferencePreferences < ActiveRecord::Migration[5.1]
  def self.up
    remove_reference :conference_preferences, :conference
  end

  def self.down
    add_reference :conference_preferences, :conf
  end
end