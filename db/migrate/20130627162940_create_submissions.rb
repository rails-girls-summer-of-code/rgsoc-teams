class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :mailing
      t.string :to
      t.text :error
      t.timestamp :sent_at
      t.timestamps
    end
  end
end
