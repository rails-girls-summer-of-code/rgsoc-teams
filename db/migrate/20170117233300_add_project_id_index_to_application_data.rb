class AddProjectIdIndexToApplicationData < ActiveRecord::Migration[5.0]
  def up
    execute "CREATE INDEX application_data_project1_id ON applications ((application_data -> 'project1_id'))"
    execute "CREATE INDEX application_data_project2_id ON applications ((application_data -> 'project2_id'))"
  end

  def down
    execute "DROP INDEX application_data_project1_id"
    execute "DROP INDEX application_data_project2_id"
  end
end
