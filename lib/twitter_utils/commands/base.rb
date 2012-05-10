require 'active_support/core_ext/string'
require 'myoack'
require 'optparse'
require 'twitter'
require 'twitter_utils/commands'
require 'clamp'

module TwitterUtils::Commands

  class Base < Clamp::Command
    
    def api
      cfg = Myoack::Config.require_config(:twitter)
      @twitter ||= Twitter.configure do |config|
        config.consumer_key = cfg.consumer_key
        config.consumer_secret = cfg.consumer_secret
        config.oauth_token = cfg.access_token
        config.oauth_token_secret = cfg.access_token_secret
      end
    end
  end
end