class AddProjectRefToTeam < ActiveRecord::Migration[5.1]
  def change
    add_reference :teams, :project, foreign_key: true
  end
end
