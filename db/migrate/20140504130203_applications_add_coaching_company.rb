class ApplicationsAddCoachingCompany < ActiveRecord::Migration
  def change
    change_table :applications do |t|
      t.string :coaching_company
    end
  end
end
