class AddProjectIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :project_id, :integer
    add_index :comments, :project_id
  end
end
