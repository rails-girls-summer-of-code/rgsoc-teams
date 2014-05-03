class ApplicationsAddFlags < ActiveRecord::Migration
  def change
    change_table :applications do |t|
      t.text :flags, array: true, default: '{}'
    end
  end
end
