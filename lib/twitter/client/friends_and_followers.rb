require 'twitter/cursor'

module Twitter
  class Client
    # Defines methods related to friends and followers
    module FriendsAndFollowers
      # @see https://dev.twitter.com/docs/api/1/get/friends/ids
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload friend_ids(options={})
      #   Returns an array of numeric IDs for every user the authenticated user is following
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return the authenticated user's friends' IDs
      #     Twitter.friend_ids
      # @overload friend_ids(user, options={})
      #   Returns an array of numeric IDs for every user the specified user is following
      #
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return @sferik's friends' IDs
      #     Twitter.friend_ids("sferik")
      #     Twitter.friend_ids(7505382)  # Same as above
      def friend_ids(*args)
        options = {:cursor => -1}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.first
        merge_user_into_options!(user, options)
        cursor = get("/1/friends/ids.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end

      # @see https://dev.twitter.com/docs/api/1/get/followers/ids
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload follower_ids(options={})
      #   Returns an array of numeric IDs for every user following the authenticated user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return the authenticated user's followers' IDs
      #     Twitter.follower_ids
      # @overload follower_ids(user, options={})
      #   Returns an array of numeric IDs for every user following the specified user
      #
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return @sferik's followers' IDs
      #     Twitter.follower_ids("sferik")
      #     Twitter.follower_ids(7505382)  # Same as above
      def follower_ids(*args)
        options = {:cursor => -1}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.first
        merge_user_into_options!(user, options)
        cursor = get("/1/followers/ids.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end
    end
  end
end
