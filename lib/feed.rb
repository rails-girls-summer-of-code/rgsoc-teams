# frozen_string_literal: true

require 'feedjira'

require 'error_reporting'
require 'feed/discovery'
require 'feed/image'
require 'feed/item'
require 'feed/s3'

class Feed
  class << self
    def update_all
      Source.for_accepted_teams.where(kind: 'blog').each do |source|
        new(source).update
      end
    end
  end

  attr_reader :source, :logger

  # @param source [Source]
  # @param logger [Logger] an optional logger instance. Logs to STDOUT by default.
  def initialize(source, logger: Logger.new(STDOUT))
    @source = source
    @logger = logger
  end

  def update
    source.update_attributes!(title: discover_title) unless source.title.present?
    source.feed_url = discover_feed_url unless source.feed_url.present?
    update_entries
    source.save! if source.feed_url_changed? && source.feed_url != source.url
  rescue => e
    ErrorReporting.call(e)
    puts e.message
    puts e.backtrace
  end

  private

  def discover_title
    title = Discovery.new(source.url, logger: logger).title
    logger.info "discovered title for #{source.url}: #{title}"
    title
  end

  def discover_feed_url
    urls = Discovery.new(source.url, logger: logger).feed_urls
    url = urls.reject { |url| url =~ /comment/ }.first
    logger.info "discovered feed url for #{source.url}: #{url}" if url
    url || source.url
  end

  def update_entries
    parse.entries.each do |data|
      item = Item.new(source.url, source.team_id, data)
      raise "can not find guid for item in source #{source.feed_url}" unless item.guid
      # logger.info "processing item #{item.guid}: #{item.title}"
      record = Activity.where(guid: item.guid).first
      attrs = item.attrs.merge(img_url: record.try(:img_url) || Image.new(item.url, logger: logger).store)
      record ? record.update_attributes!(attrs) : Activity.create!(attrs)
    end
  rescue => e
    ErrorReporting.call(e)
    logger.error "Could not update entries: #{e.message}"
    nil
  end

  def parse
    logger.info "Feeds: going to fetch #{source.feed_url}"
    data = Feedjira::Feed.fetch_and_parse(source.feed_url)
    logger.info "this does not look like a valid feed" unless data.respond_to?(:entries)
    data
  end
end
