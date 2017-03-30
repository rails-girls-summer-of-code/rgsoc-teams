class RemoveSponsorPick < ActiveRecord::Migration[5.0]
  def change
    remove_column :applications, :sponsor_pick, :string
  end
end
