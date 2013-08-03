class Feed
  class S3
    class << self
      def setup(options)
        AWS.config(access_key_id: options[:access_key_id], secret_access_key: options[:secret_access_key])
      end
    end

    attr_reader :s3, :url

    def initialize(url)
      @s3 = AWS::S3.new
      @url = url
    end

    def store(data, content_type)
      object.write(data, content_type: content_type, acl: :public_read)
    rescue => e
      puts "Could not store to S3: #{e.message}"
    end

    def object
      @object ||= bucket.objects[path]
    end

    def bucket
      @bucket ||= s3.buckets['rgsoc']
    end

    def path
      "images/#{url.gsub(%r(https?://), '').gsub(%r(//), '/')}"
    end
  end
end
