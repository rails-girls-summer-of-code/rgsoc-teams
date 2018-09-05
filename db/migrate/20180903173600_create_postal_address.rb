class CreatePostalAddress < ActiveRecord::Migration[5.1]
  def change
    create_table :postal_addresses do |t|
      t.string :street
      t.string :zip
      t.string :state

      t.references :user, foreign_key: true
    end
  end
end
