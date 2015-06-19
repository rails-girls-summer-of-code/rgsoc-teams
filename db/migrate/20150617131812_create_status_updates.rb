class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.integer :team_id
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
    add_index :status_updates, :team_id
  end
end
