class CreatePostalAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :postal_addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state_or_province
      t.string :postal_code
      t.string :country

      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
