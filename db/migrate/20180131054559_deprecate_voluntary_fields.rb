class DeprecateVoluntaryFields < ActiveRecord::Migration[5.1]
  def change
    rename_column :application_drafts, :voluntary, :deprecated_voluntary
    rename_column :application_drafts, :voluntary_hours_per_week, :deprecated_voluntary_hours_per_week
  end
end
