require 'twitter_utils/commands/base'
require 'pp'
require 'give4each'

module TwitterUtils::Commands

  class Followall < Base
    option ['--tags'], 'TAGS', 'searching hash-tags to follow.', :default => [] do |tags|
      tags.split(',').map &:+.in('#') 
    end
    option ['--cluster'], 'CLUSTER', "searching words in each user's bio to follow.", :default => [] do |words|
      words.split(/[\,\/]/)
    end
    
    def execute
      followed_user_ids = api.friend_ids.collection

      hash_tagged_user_ids = tags.map do |tag|
        api.search(tag).map &:from_user_id
      end.flatten.uniq.reject &:include?.in( followed_user_ids )
      
      users = hash_tagged_user_ids.map { |id| api.user(id) }
      users.select! do |user|
        cluster.all? do |c|
          user.description =~ /#{Regexp.quote c}/i
        end
      end

      puts "This program will follow #{users.count} users:"
      pp users.map &:screen_name

      loop do
        puts "Do you follow them really? [Y/N]"
        case STDIN.gets.chomp
        when /Y/i, /Yes/i
          puts "unimplemented."
          break
        when /N/i, /No/i
          puts "was canceled."
          break
        end
      end
    end
  end
end