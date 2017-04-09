class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.integer :application_id
      t.integer :user_id

      t.timestamps
    end

    # make sure we don't assign a reviewer twice
    add_index :todos, [:user_id, :application_id], unique: true
  end
end
