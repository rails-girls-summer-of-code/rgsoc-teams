class ReplaceApplicationsProjectNameWithId < ActiveRecord::Migration
  def up
    add_column :applications, :project_id, :integer
    add_index :applications, :project_id
    remove_column :applications, :project_name
  end

  def down
    remove_index :applications, :project_id
    remove_column :applications, :project_id
    add_column :applications, :project_name, :string
  end
end
