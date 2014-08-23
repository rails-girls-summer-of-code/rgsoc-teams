class CreateConferencesAndAttendances < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.string :location
      t.string :twitter
      t.string :url
      t.date :starts_on
      t.date :ends_on
      t.integer :tickets
      t.integer :accomodation
      t.integer :flights
    end

    create_table :attendances do |t|
      t.belongs_to :conference
      t.belongs_to :user
    end
  end
end
