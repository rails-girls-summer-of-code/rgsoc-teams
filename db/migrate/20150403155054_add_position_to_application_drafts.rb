class AddPositionToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :position, :integer
  end
end
