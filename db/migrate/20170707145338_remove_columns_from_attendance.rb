class RemoveColumnsFromAttendance < ActiveRecord::Migration[5.1]
  def up
  	 remove_column :attendances, :conference_id
  	remove_column :attendances, :user_id
  end

  def down
  	 add_column :attendances, :conference_id, :integer
  	add_column :attendances, :user_id, :integer
  end
end
