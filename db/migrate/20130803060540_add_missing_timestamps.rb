class AddMissingTimestamps < ActiveRecord::Migration
  def change
    add_column :attendances, :created_at, :datetime
    add_column :attendances, :updated_at, :datetime
    connection.execute "UPDATE attendances SET created_at='#{Time.now}' WHERE created_at IS NULL"
    connection.execute "UPDATE attendances SET updated_at='#{Time.now}' WHERE updated_at IS NULL"

    add_column :conferences, :created_at, :datetime
    add_column :conferences, :updated_at, :datetime
    connection.execute "UPDATE conferences SET created_at='#{Time.now}' WHERE created_at IS NULL"
    connection.execute "UPDATE conferences SET updated_at='#{Time.now}' WHERE updated_at IS NULL"

    connection.execute "UPDATE comments SET created_at='#{Time.now}' WHERE created_at IS NULL"
    connection.execute "UPDATE comments SET updated_at='#{Time.now}' WHERE updated_at IS NULL"
  end
end
