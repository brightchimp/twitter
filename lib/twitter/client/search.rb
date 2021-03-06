require 'twitter/status'

module Twitter
  class Client
    # Defines methods related to Search
    module Search
      # Returns recent statuses that contain images related to a query
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication No
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::Status>] An array of statuses that contain images
      # @example Return recent statuses that contain images related to a query
      #   Twitter.images('twitter')
      def images(q, options={})
        get("/i/search/image_facets.json", options.merge(:q => q), :phoenix => true).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns recent statuses that contain videos related to a query
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication No
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::Status>] An array of statuses that contain videos
      # @example Return recent statuses that contain videos related to a query
      #   Twitter.videos('twitter')
      def videos(q, options={})
        get("/i/search/video_facets.json", options.merge(:q => q), :phoenix => true).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns recent statuses related to a query with images and videos embedded
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication No
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @return [Array<Twitter::Status>] An array of statuses that contain videos
      # @example Return recent statuses related to twitter with images and videos embedded
      #   Twitter.search('twitter')
      def search(q, options={})
        get("/phoenix_search.phoenix", options.merge(:q => q), :phoenix => true)['statuses'].map do |status|
          Twitter::Status.new(status)
        end
      end
    end
  end
end
