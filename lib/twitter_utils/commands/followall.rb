require 'twitter_utils/commands/base'
require 'give4each'

module TwitterUtils::Commands

  class Followall < Base
    option ['--tags'], 'TAGS', 'searching hash-tags to follow.', :default => [] do |tags|
      tags.split(',').map &:+.in('#') 
    end

    option ['--cluster'], 'CLUSTER', "searching words in each user's bio to follow.", :default => [] do |words|
      words.split(/[\,\/]/)
    end

    # option ['-f', '--force'], :flag, "force following. (NO ALL WARNING.)", :default => false
    
    def execute
      followed_user_ids = api.friend_ids.collection

      hash_tagged_user_ids = tags.map do |tag|
        [].tap do |r|
          begin
            ids = api.search(tag, :rpp => 100).map &:from_user_id
            r.concat ids
          end while ids.count == 100
        end
      end.flatten.uniq.reject &:include?.in( [api.user.id, *followed_user_ids] )
      
      users = hash_tagged_user_ids.map { |id| api.user(id) }
      users.select! do |user|
        cluster.all? do |c|
          user.description =~ /#{Regexp.quote c}/i
        end
      end
      
      puts "This program will follow #{users.count} users:"
      users.each do |user|
        puts "%s%s: %d tweets. %d friends. %d followers." % [
          user.screen_name,
          ' ' * (20 - user.screen_name.length),
          user.statuses_count,
          user.friends_count,
          user.followers_count]
      end

      loop do
        puts "Do you follow them really? [Y/N]"
        case STDIN.gets.chomp
        when /Y/i, /Yes/i
          users.each { |user| api.follow(user.id) }
          break
        when /N/i, /No/i
          puts "was canceled."
          break
        end
      end
    end
  end
end