class Feed
  class Item
    attr_reader :team_id, :item

    def initialize(team_id, item)
      @team_id = team_id
      @item = item
    end

    def attrs
      @attrs ||= {
        team_id:      team_id,
        kind:         :feed_entry,
        guid:         guid,
        title:        item.title,
        content:      item.content || item.description,
        author:       item.author,
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

    def url
      %i(entry_id url).map { |attr| item.send(attr) }.detect { |url| url =~ /^http/ }
    end
  end
end
