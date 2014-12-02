require './config/boot'
require './config/environment'
require 'clockwork'
require 'twitter'

module Clockwork

  every(6.hours, "[#{DateTime.now.to_s}] Following a user") do
    begin
      handle = Handle.where(followed: false, unfollowed: false).sample
      follow(handle)
    rescue Exception => e
      puts "Fail while attempting to follow a user"
      puts e.message
    end
  end

  every(3.hours, "[#{DateTime.now.to_s}] Unfollowing a user") do
    begin
      handle = Handle.where(followed: true, unfollowed: false, :followed_at.lte => 3.days.ago).last
      unfollow(handle)
    rescue Exception => e
      puts "Fail while attempting to unfollow a user"
      puts e.message
    end
  end

  class << self

    def follow(handle)
      if handle
        client = get_client
        client.follow(handle.handle)
        handle.followed = true
        handle.followed_at = DateTime.current
        handle.save
        puts "followed #{handle.handle}"
      end
    end

    def unfollow(handle)
      if handle
        client = get_client
        client.unfollow(handle.handle)
        handle.unfollowed = true
        handle.unfollowed_at = DateTime.current
        handle.save
        puts "unfollowed #{handle.handle}"
      end
    end

    def get_client
      @post_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      end
    end
  end
end
