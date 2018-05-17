class RemoveConferencePreferencesWithoutTeam < ActiveRecord::Migration[5.1]
  def up
    execute <<~SQL
      DELETE
      FROM conference_preferences
      WHERE team_id IS NULL
    SQL
  end
end
