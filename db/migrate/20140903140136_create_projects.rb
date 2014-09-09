class CreateProjects < ActiveRecord::Migration
  Team.all do |team|
    Project.create(name: team.project, team: team)
  end

  def change
    create_table :projects do |t|
      t.string :name
      t.integer :team_id

      t.timestamps
    end
  end
end
