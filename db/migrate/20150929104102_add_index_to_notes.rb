class AddIndexToNotes < ActiveRecord::Migration
  def change
    add_index :notes, :user_id
  end
end
