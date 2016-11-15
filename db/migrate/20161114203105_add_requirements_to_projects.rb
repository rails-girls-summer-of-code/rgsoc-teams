class AddRequirementsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :requirements, :text
  end
end
