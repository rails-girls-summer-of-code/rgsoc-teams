class CreateMaintainerships < ActiveRecord::Migration[5.1]
  def change
    create_table :maintainerships do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
    add_index :maintainerships, :project_id
    add_index :maintainerships, :user_id
    add_index :maintainerships, [:project_id, :user_id], unique: true
  end
end
