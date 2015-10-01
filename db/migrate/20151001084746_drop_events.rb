class DropEvents < ActiveRecord::Migration
  def up
    drop_table :events
    remove_column :teams, :event_id
  end

  def down
    add_column :teams, :events_id, :integer
    create_table :events do |t|
      t.string   "name",       limit: 255
      t.date     "start_date"
      t.date     "end_date"
      t.timestamps
    end
  end
end
