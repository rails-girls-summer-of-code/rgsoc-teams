# frozen_string_literal: true

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

    def fetch_json(url)
      resp = Net::HTTP.get_response(URI.parse(url))
      data = resp.body
      JSON.parse(data)
    end

    def fetch
      params = {
        p2i_url: URI.encode(url),
        p2i_screen: '640x400',
        p2i_key: ENV['P2I_KEY']
      }
      response = fetch_json("http://api.page2images.com/restfullink?#{params.to_param}")
      open(response['image_url'])
    rescue => e
      ErrorReporting.call(e)
      logger.error "Could not fetch image for #{url}: #{e.message}"
      nil
    end
  end
end
