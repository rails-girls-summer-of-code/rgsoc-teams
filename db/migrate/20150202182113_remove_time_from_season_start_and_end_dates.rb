class RemoveTimeFromSeasonStartAndEndDates < ActiveRecord::Migration
  def change
    change_column :seasons, :starts_at, :date
    change_column :seasons, :ends_at, :date
  end
end
