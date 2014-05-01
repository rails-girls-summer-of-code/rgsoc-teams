class ApplicationsAddSponsorPickAndProjectVisibility < ActiveRecord::Migration
  def change
    change_table :applications do |t|
      t.string :sponsor_pick
      t.integer :project_visibility
      t.string :project_name
    end
  end
end
