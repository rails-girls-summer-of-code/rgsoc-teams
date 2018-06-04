class RemoveOrphanedConferencePreferences < ActiveRecord::Migration[5.1]
  def up
    execute <<~SQL
      DELETE
      FROM conference_preferences
      WHERE first_conference_id IS NULL AND second_conference_id IS NULL
    SQL
  end
end
