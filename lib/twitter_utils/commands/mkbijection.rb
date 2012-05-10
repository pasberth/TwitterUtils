require 'twitter_utils/commands/base'

module TwitterUtils::Commands

  class Mkbijection < Base
  
    option ['-l', '--list'], 'NAME', 'List name of saving on bijection list.', :default => 'bijection'
    option ['-m', '--mode'], 'MODE', 'List mode of bijection list. "public" or "private".', :default => 'private'
    option ['--description'], 'DESCRIPTION', '', :default => 'bijection list auto-created by TwitterUtils. https://github.com/pasberth/TwitterUtils'
    option ['-f', '--force'], :flag, '', :default => false
    option ['--[no-]create-list'], :flag, '', :default => true
    option ['--[no-]rewrite-list'], :flag, '', :default => false
    
    def execute
      if api.lists.lists.map(&:name).include? list
        if rewrite_list?
        end
      elsif create_list?
        l = api.list_create list, :mode => mode, :description => description
        bijection_ids = api.friend_ids.collection & api.follower_ids.collection
        bijection_ids.each_slice 100 do |ids|
          retry_times = 5
          begin
            api.list_add_members list, ids
          rescue Twitter::Error::BadGateway
            (retry_times -= 1; retry) if retry_times > 0
          end
        end
        puts "New bijection list '#{l.full_name}' created. #{bijection_ids.count} users."
      end
    end
  end
end