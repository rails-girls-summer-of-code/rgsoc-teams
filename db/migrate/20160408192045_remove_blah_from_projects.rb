class RemoveBlahFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :blah, :string
  end
end
