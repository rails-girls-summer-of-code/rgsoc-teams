class RatingsPolymorphicRateable < ActiveRecord::Migration
  def change
    add_column :ratings, :rateable_id, :integer
    add_column :ratings, :rateable_type, :string
    add_index :ratings, [:rateable_id, :rateable_type]
  end
end
