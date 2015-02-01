class AddApplicationDatesToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :applications_open_at, :datetime
    add_column :seasons, :applications_close_at, :datetime
  end
end
