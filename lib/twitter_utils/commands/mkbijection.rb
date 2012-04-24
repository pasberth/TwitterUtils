require 'twitter_utils/commands/base'

module TwitterUtils::Commands

class Mkbijection < Base
  
  def option_parser
    OptionParser.new.tap do |opts|
      opts.on '-l NAME', '--list=NAME', 'List name of saving on bijection list. default is "bijection".' do |bijection_list_name|
        @bijection_list_name = bijection_list_name
      end
      opts.on '-m MODE', '--mode=MODE', 'List mode of bijection list. "public" or "private". defualt is "private".' do |mode| @mode = mode end
      opts.on '--description=DESC' do |desc| @desc = desc end
      opts.on '-f', '--force' do |f| @force = f end
      opts.on '--[no-]create-list', 'Create a new list and write into the list unless the list exist. default is true.' do |c| @create = c end
      opts.on '--[no-]rewrite-list', 'Rewrite the list. default is false.' do |rw| @rewrite = rw end
    end
  end

  def __main__ *argv
    require 'pp'
    @bijection_list_name ||= 'bijection'
    @mode ||= 'private'
    @desc ||= 'bijection list auto-created by TwitterUtils. https://github.com/pasberth/TwitterUtils'
    @force.nil? and @force = false
    @create.nil? and @create = true
    @rewrite.nil? and @rewrite = false

    if api.lists.lists.map(&:name).include? @bijection_list_name
      if @rewrite
      end
    elsif @create
      list = api.list_create @bijection_list_name, :mode => @mode, :description => @desc
      bijection_ids = api.friend_ids.collection & api.follower_ids.collection
      bijection_ids.each_slice 100 do |ids|
        retry_times = 5
        begin
          api.list_add_members @bijection_list_name, ids
        rescue Twitter::Error::BadGateway
          (retry_times -= 1; retry) if retry_times > 0
        end
      end
      puts "New bijection list '#{list.full_name}' created. #{bijection_ids.count} users."
    end
  end
end
end