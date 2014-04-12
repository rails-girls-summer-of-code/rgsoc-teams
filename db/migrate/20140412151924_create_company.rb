class CreateCompany < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.timestamps
      t.string :name, :website
      t.integer :student_slots, :coaches_number, :owner_id
    end
  end
end
