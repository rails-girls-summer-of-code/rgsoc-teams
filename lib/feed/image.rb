require 'aws/s3'
require 'open-uri'

class Feed
  class Image
    attr_reader :url, :s3

    def initialize(url)
      @url = url
      @s3 = S3.new(url)
    end

    def store
      puts "fetching image for #{url} ..."
      if image = fetch
        puts "storing image for #{url} ..."
        s3.store(image, image.content_type)
        "https://s3.amazonaws.com/rgsoc/#{s3.path}"
      end
    end

    def fetch
      open("http://api.snapito.com/web/#{ENV['SNAPITO_KEY']}/mc?url=#{URI::encode(url)}&fast&freshness=0")
    rescue => e
      puts "Could not fetch image for #{url}: #{e.message}"
      nil
    end
  end
end

