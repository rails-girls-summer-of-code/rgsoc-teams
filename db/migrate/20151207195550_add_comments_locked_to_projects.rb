class AddCommentsLockedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :comments_locked, :boolean, default: false
  end
end
