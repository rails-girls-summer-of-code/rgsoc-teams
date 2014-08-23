class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :team
      t.string :kind
      t.string :guid
      t.string :author
      t.string :title
      t.text   :content
      t.string :source_url
      t.datetime :published_at
      t.timestamps
    end
  end
end
