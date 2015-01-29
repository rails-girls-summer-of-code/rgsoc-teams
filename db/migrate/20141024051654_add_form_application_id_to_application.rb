class AddFormApplicationIdToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :form_application_id, :integer
  end
end
