class RemoveColumnFromConferencePreference < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :conference_preferences, :option
    remove_reference :conference_preferences, :conference
  end

  def self.down
    add_column :conference_preferences, :option, :integer
    add_reference :conference_preferences, :conference
  end
end
