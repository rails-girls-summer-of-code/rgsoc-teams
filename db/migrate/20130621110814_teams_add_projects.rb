class TeamsAddProjects < ActiveRecord::Migration
  def change
    add_column :teams, :projects, :string
  end
end
