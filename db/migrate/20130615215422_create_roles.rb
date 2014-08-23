class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :team
      t.references :user
      t.string :name
      t.timestamps
    end
  end
end
