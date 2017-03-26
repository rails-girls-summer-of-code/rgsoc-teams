class RatingsAddLike < ActiveRecord::Migration
  def change
    change_table :ratings do |t|
      t.boolean :like
    end
  end
end
