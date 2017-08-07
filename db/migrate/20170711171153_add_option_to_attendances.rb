class AddOptionToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :option, :integer
  end
end
