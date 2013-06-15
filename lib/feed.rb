require 'open-uri'
require 'simple-rss'

class Feed
  class << self
    def update_all
      Team.all.each do |team|
        Feed.new(team.id, team.log_url).update
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
      create_activity(item) unless Activity.exists?(:guid => item.id)
    end
  end

  private

    def parse
      silence_warnings do
        SimpleRSS.parse(fetch)
      end
    end

    def fetch
      open(source)
    end

    def create_activity(item)
      Activity.create!(
        team_id:      team_id,
        kind:         :feed_entry,
        guid:         item.id,
        title:        item.title,
        content:      item.content,
        author:       item.author,
        source_url:   item.link,
        published_at: item.published
      )
    end
end
