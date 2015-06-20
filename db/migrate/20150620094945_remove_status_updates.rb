class RemoveStatusUpdates < ActiveRecord::Migration
  def up
    drop_table :status_updates
  end

  def down
    create_table :status_updates do |t|
      t.integer :team_id
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
    add_index :status_updates, :team_id
  end
end
