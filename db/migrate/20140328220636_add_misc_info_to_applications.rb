class AddMiscInfoToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :misc_info, :text
  end
end
