class RemoveProjectVisibilityFromApplications < ActiveRecord::Migration[5.0]
  def change
    remove_column :applications, :project_visibility, :integer
  end
end
