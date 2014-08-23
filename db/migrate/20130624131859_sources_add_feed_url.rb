class SourcesAddFeedUrl < ActiveRecord::Migration
  def change
    add_column :sources, :feed_url, :string
  end
end
