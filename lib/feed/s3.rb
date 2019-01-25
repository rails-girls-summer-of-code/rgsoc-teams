# frozen_string_literal: true

class Feed
  class S3
    attr_reader :s3, :url, :logger

    def initialize(url, options = {})
      @s3 = Aws::S3::Resource.new(stub_responses: Rails.env.test?)
      @url = url
      @logger = options[:logger] || Logger.new(STDOUT)
    end

    def store(data, content_type)
      object.put(body: data, content_type: content_type, acl: :public_read)
    rescue => e
      logger.error "Could not store to S3: #{e.message}"
    end

    def object
      @object ||= bucket.object(path)
    end

    def bucket
      @bucket ||= s3.bucket('rgsoc')
    end

    def path
      "images/#{url.gsub(%r(https?://), '').gsub(%r(//), '/')}"
    end
  end
end
