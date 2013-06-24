class Feed
  class Item
    attr_reader :team_id, :item

    delegate :title, :content, :author, :url, to: :item

    def initialize(team_id, item)
      @team_id = team_id
      @item = item
    end

    def attrs
      @attrs ||= {
        team_id:      team_id,
        kind:         :feed_entry,
        guid:         guid,
        title:        title,
        content:      content,
        author:       author,
        source_url:   url,
        published_at: published_at
      }
    end

    def guid
      item.id || item.guid
    end

    def published_at
      item.published || item.updated || item.pubDate
    end
  end
end
