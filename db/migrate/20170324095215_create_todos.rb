class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.belongs_to :application, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
