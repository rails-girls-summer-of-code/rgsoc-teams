class CreateMailings < ActiveRecord::Migration
  def change
    create_table :mailings do |t|
      t.string :from
      t.string :to
      t.string :cc
      t.string :bcc
      t.string :subject
      t.text :body
      t.timestamp :sent_at
      t.timestamps
    end
  end
end
