class AddApplicationIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :application_id, :integer
  end
end
