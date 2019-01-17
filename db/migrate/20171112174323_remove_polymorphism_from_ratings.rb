class RemovePolymorphismFromRatings < ActiveRecord::Migration[5.1]
  class Rating < ApplicationRecord
    self.table_name = :ratings
  end

  def up
    add_index :ratings, :application_id
    remove_index :ratings, column: [:rateable_id, :rateable_type]
    migrate_and_remove_existing_records
    remove_column :ratings, :rateable_type, :string
    remove_column :ratings, :rateable_id, :integer
  end

  def down
    add_column :ratings, :rateable_type, :string
    add_column :ratings, :rateable_id, :integer
    add_index :ratings, [:rateable_id, :rateable_type]
    remove_index :ratings, column: [:application_id]
    migrate_records_back
  end

  def migrate_and_remove_existing_records
    Rating.where(rateable_type: 'Application').find_each do |rating|
      rating.update(application_id: rating.rateable_id)
    end
    Rating.where(application_id: nil).destroy_all
  end

  def migrate_records_back
    Rating.find_each do |rating|
      rating.update(rateable_id: rating.application_id, rateable_type: 'Application')
    end
  end
end
