class SetProjectsName < ActiveRecord::Migration
  def up
      Team.all.each do |team|
        team.update_attributes({is_selected: true})  #this attribute is updated because the existing teams have is_selected column to false. To make the appropriate edit forms visible for the team, this is set true for existing teams
        Project.create(name: team.projects, team: team)
      end
    end

    def down
      Project.delete_all
    end
  end