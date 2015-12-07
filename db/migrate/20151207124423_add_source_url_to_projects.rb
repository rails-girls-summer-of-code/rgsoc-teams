class AddSourceUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :source_url, :string
  end
end
