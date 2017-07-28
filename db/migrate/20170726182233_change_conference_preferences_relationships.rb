class ChangeConferencePreferencesRelationships < ActiveRecord::Migration[5.1]
  def up
    remove_reference :conference_preferences, :team
    add_reference :conference_preferences, :conference_preference_info
  end

  def down
    add_reference :conference_preferences, :team
    remove_reference :conference_preferences, :conference_preference_info
  end
end
