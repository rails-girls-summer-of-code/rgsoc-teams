class CreatePostalAddress < ActiveRecord::Migration[5.1]
  def change
    create_table :postal_addresses do |t|
      t.string :street
      t.string :state
      t.string :zip
      t.references :user, foreign_key: true
    end
  end
end
