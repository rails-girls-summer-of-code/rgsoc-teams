class AddCodeOfConductToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :code_of_conduct, :string
  end
end
