# frozen_string_literal: true

require 'open-uri'

class Feed
  class Discovery
    attr_reader :url, :logger

    def initialize(url, options = {})
      @url = url
      @logger = options[:logger] || Logger.new(STDOUT)
    end

    def title
      html =~ %r(<title>(.*)</title) && $1.strip || nil
    end

    def feed_urls
      urls.map { |url| expand(url) }
    end

    private

    def html
      open(url).read
    end

    def expand(url)
      url =~ /^http/ ? url : base_url + url
    end

    def base_url
      (url =~ %r(^(https?://[^/]+)) && $1).to_s
    end

    def urls
      tags.map { |tag| tag.match(/.*href=['"](.*?)['"].*/) && $1 }.compact
    end

    def tags
      html.scan(/(<(a|link)[^>]*>)/).flatten.select do |tag|
        tag =~ /.*type=['"]application\/(rss|atom)\+xml['"].*/
      end
    end
  end
end
