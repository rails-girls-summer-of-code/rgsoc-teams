class AttendancesAddConfirmed < ActiveRecord::Migration
  def change
    add_column :attendances, :confirmed, :boolean
  end
end
