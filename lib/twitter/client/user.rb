require 'twitter/error/not_found'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to users
    module User
      # Returns extended information of a given user
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/show
      # @rate_limited Yes
      # @requires_authentication No
      # @overload user(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Twitter::User] The requested user.
      #   @example Return extended information for @sferik
      #     Twitter.user("sferik")
      #     Twitter.user(7505382)  # Same as above
      def user(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.pop || get_screen_name
        merge_user_into_options!(user, options)
        user = get("/1/users/show.json", options)
        Twitter::User.new(user)
      end

      # Returns true if the specified user exists
      #
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @return [Boolean] true if the user exists, otherwise false.
      # @example Return true if @sferik exists
      #     Twitter.user?("sferik")
      #     Twitter.user?(7505382)  # Same as above
      # @requires_authentication No
      # @rate_limited Yes
      def user?(user, options={})
        merge_user_into_options!(user, options)
        get("/1/users/show.json", options, :raw => true)
        true
      rescue Twitter::Error::NotFound
        false
      end

      # Returns extended information for up to 100 users
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/lookup
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload users(*users, options={})
      #   @param users [Integer, String] Twitter users ID or screen names.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::User>] The requested users.
      # @example Return extended information for @sferik and @pengwynn
      #   Twitter.users("sferik", "pengwynn")
      #   Twitter.users("sferik", 14100886)   # Same as above
      #   Twitter.users(7505382, 14100886)    # Same as above
      def users(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        users = args
        merge_users_into_options!(Array(users), options)
        get("/1/users/lookup.json", options).map do |user|
          Twitter::User.new(user)
        end
      end

      # Returns users that match the given query
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/search
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param query [String] The search query to run against people search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :per_page The number of people to retrieve. Maxiumum of 20 allowed per page.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::User>]
      # @example Return users that match "Erik Michaels-Ober"
      #   Twitter.user_search("Erik Michaels-Ober")
      def user_search(query, options={})
        get("/1/users/search.json", options.merge(:q => query)).map do |user|
          Twitter::User.new(user)
        end
      end

      # @overload suggestions(options={})
      #   Returns the list of suggested user categories
      #
      #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions
      #   @rate_limited Yes
      #   @requires_authentication No
      #   @param options [Hash] A customizable set of options.
      #   @return [Array]
      #   @example Return the list of suggested user categories
      #     Twitter.suggestions
      # @overload suggestions(slug, options={})
      #   Returns the users in a given category
      #
      #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug
      #   @rate_limited Yes
      #   @requires_authentication No
      #   @param slug [String] The short name of list or a category.
      #   @param options [Hash] A customizable set of options.
      #   @return [Array]
      #   @example Return the users in the Art & Design category
      #     Twitter.suggestions("art-design")
      def suggestions(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if slug = args.first
          get("/1/users/suggestions/#{slug}.json", options)
        else
          get("/1/users/suggestions.json", options)
        end
      end

      # Access the users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug/members
      # @rate_limited Yes
      # @requires_authentication No
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::User>]
      # @example Return the users in the Art & Design category and their most recent status if they are not a protected user
      #   Twitter.suggest_users("art-design")
      def suggest_users(slug, options={})
        get("/1/users/suggestions/#{slug}/members.json", options).map do |user|
          Twitter::User.new(user)
        end
      end

      # Access the profile image in various sizes for the user with the indicated screen name
      #
      # @see https://dev.twitter.com/docs/api/1/get/users/profile_image/:screen_name
      # @rate_limited No
      # @requires_authentication No
      # @overload profile_image(screen_name, options={})
      #   @param screen_name [String] The screen name of the user for whom to return results for.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :size ('normal') Specifies the size of image to fetch. Valid options include: 'bigger' (73px by 73px), 'normal' (48px by 48px), and 'mini' (24px by 24px).
      #   @example Return the URL for the 24px by 24px version of @sferik's profile image
      #     Twitter.profile_image("sferik", :size => 'mini')
      # @return [String] The URL for the requested user's profile image.
      def profile_image(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        screen_name = args.pop || get_screen_name
        get("/1/users/profile_image/#{screen_name}", options, :raw => true).headers['location']
      end

      # Returns recommended users for the authenticated user
      #
      # @note {https://dev.twitter.com/discussions/1120 Undocumented}
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :limit (20) Specifies the number of records to retrieve.
      # @option options [String] :excluded Comma-separated list of user IDs to exclude.
      # @return [Array<Twitter::User>]
      # @example Return recommended users for the authenticated user
      #   Twitter.recommendations
      def recommendations(options={})
        options[:excluded] = options[:excluded].join(',') if options[:excluded].is_a?(Array)
        get("/1/users/recommendations.json", options).map do |recommendation|
          Twitter::User.new(recommendation['user'])
        end
      end

      # Returns an array of users that the specified user can contribute to
      #
      # @see http://dev.twitter.com/docs/api/1/get/users/contributees
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload contributees(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Twitter::User>]
      #   @example Return the authenticated user's contributees
      #     Twitter.contributees
      ## @overload contributees(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Twitter::User>]
      #   @example Return users @sferik can contribute to
      #     Twitter.contributees("sferik")
      #     Twitter.contributees(7505382)  # Same as above
      def contributees(*args)
        options = {}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.pop || get_screen_name
        merge_user_into_options!(user, options)
        get("/1/users/contributees.json", options).map do |user|
          Twitter::User.new(user)
        end
      end

      # Returns an array of users who can contribute to the specified account
      #
      # @see http://dev.twitter.com/docs/api/1/get/users/contributors
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload contributors(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Twitter::User>]
      #   @example Return the authenticated user's contributors
      #     Twitter.contributors
      ## @overload contributors(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Twitter::User>]
      #   @example Return users who can contribute to @sferik's account
      #     Twitter.contributors("sferik")
      #     Twitter.contributors(7505382)  # Same as above
      def contributors(*args)
        options = {}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.pop || get_screen_name
        merge_user_into_options!(user, options)
        get("/1/users/contributors.json", options).map do |user|
          Twitter::User.new(user)
        end
      end
    end
  end
end
