class AddTags1ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tags1, :string, array: true, default: []
  end
end
