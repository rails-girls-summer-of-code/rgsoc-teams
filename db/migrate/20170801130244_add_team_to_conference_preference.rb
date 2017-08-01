class AddTeamToConferencePreference < ActiveRecord::Migration[5.1]
  def change
    add_reference :conference_preferences, :team, foreign_key: true
  end
end
