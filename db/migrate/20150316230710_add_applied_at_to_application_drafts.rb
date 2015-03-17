class AddAppliedAtToApplicationDrafts < ActiveRecord::Migration
  def change
    add_column :application_drafts, :applied_at, :datetime
  end
end
