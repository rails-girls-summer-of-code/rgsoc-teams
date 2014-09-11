class SetProjectsName < ActiveRecord::Migration
  def up
      Team.all.each do |team|
        team.update_attributes({is_selected: true})
        Project.create(name: team.projects, team: team)
      end
    end

    def down
      Project.delete_all
    end
  end

