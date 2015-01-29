class SetProjectsName < ActiveRecord::Migration
  def up
      Team.all.each do |team|
        Project.create(name: team.projects, team: team)
      end
    end

    def down
      Project.delete_all
    end
  end
