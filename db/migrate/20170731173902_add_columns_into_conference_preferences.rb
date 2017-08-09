class AddColumnsIntoConferencePreferences < ActiveRecord::Migration[5.1]
  def self.up
    add_column :conference_preferences, :comment, :text
    add_column :conference_preferences, :lightning_talk, :boolean, default: false
  end

  def self.down
    remove_column :conference_preferences, :comment, :text
    remove_column :conference_preferences, :lightning_talk, :boolean, default: false
  end
end