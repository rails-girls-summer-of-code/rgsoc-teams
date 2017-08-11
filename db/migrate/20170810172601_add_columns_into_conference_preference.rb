class AddColumnsIntoConferencePreference < ActiveRecord::Migration[5.1]
  def self.up
    add_column :conference_preferences, :terms_of_ticket, :boolean, default: false
    add_column :conference_preferences, :terms_of_travel, :boolean, default: false
  end

  def self.down
    remove_column :conference_preferences, :terms_of_ticket
    remove_column :conference_preferences, :terms_of_travel
  end
end