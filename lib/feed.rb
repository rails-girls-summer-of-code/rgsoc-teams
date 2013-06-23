require 'feedzirra'

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

  class << self
    def update_all
      Source.where(kind: 'blog').each do |source|
        Feed.new(source.team_id, source.url).update
      end
    end
  end

  attr_reader :team_id, :source

  def initialize(team_id, source)
    @source = source
    @team_id = team_id
  end

  def update
    parse.entries.each do |data|
      item = Item.new(team_id, data)
      raise "can not find guid for item in source #{source}" unless item.guid
      # puts "processing item #{item.guid}: #{item.title}"
      record = Activity.where(:guid => item.guid).first
      record ? record.update_attributes!(item.attrs) : Activity.create!(item.attrs)
    end
  rescue => e
    puts e.message
    # puts e.backtrace
  end

  private

    def parse
      silence_warnings do
        puts "Feeds: going to fetch #{source}"
        data = Feedzirra::Feed.fetch_and_parse(source)
        puts "this does not look like a valid feed" unless data.respond_to?(:entries)
        data
      end
    end

    def fetch
      puts "Feeds: going to fetch #{source}"
      open(source)
    end
end
