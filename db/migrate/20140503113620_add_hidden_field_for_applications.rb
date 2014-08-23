class AddHiddenFieldForApplications < ActiveRecord::Migration
  def change
    add_column :applications, :hidden, :boolean
  end
end
