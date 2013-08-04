require 'aws/s3'
require 'open-uri'

class Feed
  class Image
    attr_reader :url, :s3, :logger

    def initialize(url, options)
      @url = url
      @s3 = S3.new(url, options)
      @logger = options[:logger] || Logger.new(STDOUT)
    end

    def store
      logger.info "fetching image for #{url} ..."
      if image = fetch
        logger.info "storing image for #{url} ..."
        s3.store(image, image.content_type)
        "https://s3.amazonaws.com/rgsoc/#{s3.path}"
      end
    end

    def fetch
      open("http://api.snapito.com/web/#{ENV['SNAPITO_KEY']}/mc?url=#{URI::encode(url)}&fast&freshness=0")
    rescue => e
      logger.error "Could not fetch image for #{url}: #{e.message}"
      nil
    end
  end
end

