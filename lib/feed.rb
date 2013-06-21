require 'open-uri'
require 'simple-rss'

class Feed
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
    parse.items.each do |item|
      attrs  = attrs_for(item)
      record = Activity.where(:guid => item.id).first
      record ? record.update_attributes!(attrs) : Activity.create!(attrs)
    end
  rescue => e
    puts e.message
    # puts e.backtrace
  end

  private

    def parse
      silence_warnings do
        SimpleRSS.parse(fetch)
      end
    end

    def fetch
      puts "Feeds: going to fetch #{source}"
      open(source)
    end

    def attrs_for(item)
      {
        team_id:      team_id,
        kind:         :feed_entry,
        guid:         item.id,
        title:        item.title,
        content:      item.content,
        author:       item.author,
        source_url:   item.link,
        published_at: item.published || item.updated || item.pubDate
      }
    end
end
