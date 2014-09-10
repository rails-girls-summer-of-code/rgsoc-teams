class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :team_id

      t.timestamps
    end
  end

  Team.all do |team|
    Project.create(name: team.projects, team: team)
   puts "#{team.is_selected}"
  end

end
