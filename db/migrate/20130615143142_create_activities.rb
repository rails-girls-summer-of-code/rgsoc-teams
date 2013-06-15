class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :kind
      t.string :guid
      t.string :title
      t.text   :summary
      t.string :source_url
      t.datetime :published_at
      t.timestamps
    end
  end
end
