# frozen_string_literal: true

class Feed
  class Item
    attr_reader :base_url, :team_id, :item

    def initialize(base_url, team_id, item)
      @base_url = base_url
      @team_id = team_id
      @item = item
    end

    def attrs
      @attrs ||= {
        team_id:      team_id,
        kind:         :feed_entry,
        guid:         guid,
        title:        item.title,
        content:      item.content || item.summary,
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
      url = %i(url entry_id).map { |attr| item.send(attr) }.first
      url = [base_url.gsub(%r(/$), ''), url.gsub(%r(^/), '')].join('/') unless url =~ /^(http|file)/
      url
    end
  end
end
