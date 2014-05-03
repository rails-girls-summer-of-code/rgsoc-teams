class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :application
      t.string :user_name
      t.text :data

      t.timestamps
    end
  end
end
