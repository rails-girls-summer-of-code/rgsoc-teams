class AddTagsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tags, :string, array: true, default: []
  end
end
