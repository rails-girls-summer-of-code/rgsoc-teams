class AddBlahToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :blah, :string
  end
end
