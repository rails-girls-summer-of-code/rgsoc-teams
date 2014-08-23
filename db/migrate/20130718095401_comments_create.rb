class CommentsCreate < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :team
      t.belongs_to :user
      t.text :text
      t.timestamps
    end
  end
end
