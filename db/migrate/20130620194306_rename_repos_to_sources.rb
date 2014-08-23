class RenameReposToSources < ActiveRecord::Migration
  def change
    rename_table :repositories, :sources
  end
end
