# frozen_string_literal: true

require 'gh'

module Github
  class User
    attr_reader :handle, :options

    def initialize(handle, options = {})
      @handle = handle
      @options = options
    end

    def attrs
      {
        github_id:  data['id'],
        name:       data['name'],
        email:      data['email'],
        location:   data['location'],
        bio:        data['bio'],
        avatar_url: data['_links']['avatar']['href'],
        homepage:   data['_links']['blog'] && data['_links']['blog']['href']
      }
    end

    private

    def data
      @data ||= gh["users/#{handle}"]
    end

    def gh
      @gh ||= options[:gh] || GH::Stack.build do
        use GH::Normalizer
      end
    end
  end
end
