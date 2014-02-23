class AddApplicationModel < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.string :email
      t.hstore :application_data
      t.timestamps
    end
  end
end
