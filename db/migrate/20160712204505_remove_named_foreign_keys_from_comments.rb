class RemoveNamedForeignKeysFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :team_id
    remove_column :comments, :application_id
    remove_column :comments, :project_id
  end

  def down
    add_column :comments, :team_id, :integer
    add_column :comments, :application_id, :integer
    add_column :comments, :project_id, :integer
    add_index :comments, :project_id
  end
end
