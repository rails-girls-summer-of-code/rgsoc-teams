class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :teams, :projects, :work
    Team.reset_column_information
    Team.all.each do |team|
     Project.create(name: team.work, team: team)

  end
  end
  end
