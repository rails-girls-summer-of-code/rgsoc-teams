class ApplicationsAddCityAndCountry < ActiveRecord::Migration
  def change
    change_table :applications do |t|
      t.string :country
      t.string :city
    end
  end
end
