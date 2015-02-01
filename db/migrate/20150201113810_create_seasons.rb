class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :name

      t.timestamps
    end
  end
end
