class AddTagsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :tags, :text, array: true, default: []
  end
end
