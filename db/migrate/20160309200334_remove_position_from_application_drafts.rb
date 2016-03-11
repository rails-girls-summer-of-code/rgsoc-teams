class RemovePositionFromApplicationDrafts < ActiveRecord::Migration
  def change
    remove_column :application_drafts, :position, :integer
  end
end
