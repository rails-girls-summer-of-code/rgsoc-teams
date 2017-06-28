class AddColumnsToConferences < ActiveRecord::Migration[5.1]
  def change
    add_column :conferences, :gid, :integer
    add_column :conferences, :city, :string
    add_column :conferences, :country, :string
    add_column :conferences, :region, :string
    add_column :conferences, :notes, :text
  end
end
