class AddSubmittedToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :submitted, :boolean
  end
end
