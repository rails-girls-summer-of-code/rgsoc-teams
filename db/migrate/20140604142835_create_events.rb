class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_column :teams, :event_id, :integer
  end
end
