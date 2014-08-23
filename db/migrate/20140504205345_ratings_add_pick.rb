class RatingsAddPick < ActiveRecord::Migration
  def change
    change_table :ratings do |t|
      t.boolean :pick
    end
  end
end
