class AddReferencesToConferenceIntoConferencePreferences < ActiveRecord::Migration[5.1]
  def self.up
    add_reference :conference_preferences, :first_conference
    add_reference :conference_preferences, :second_conference
  end

  def self.down
    remove_reference :conference_preferences, :first_conference
    remove_reference :conference_preferences, :second_conference
  end
end
