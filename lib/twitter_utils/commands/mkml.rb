require 'twitter_utils/commands/base'
require 'super_short'

module TwitterUtils::Commands

class Mkml < Base
  
  include SuperShort::ObjectMethods
  include SuperShort::Modifiable
  
  def option_parser
    OptionParser.new.tap do |opts|
      opts.on '-l NAME', '--list=NAME', 'List name of saving on main list. default is "main".' do |mlname|
        @mlname = mlname
      end
      opts.on '-m MODE', '--mode=MODE', 'List mode of bijection list. "public" or "private". defualt is "public".' do |mode| @mode = mode end
      opts.on '--description=DESC' do |desc| @desc = desc end
      opts.on '-f', '--force' do |f| @force = f end
      opts.on '--[no-]create-list', 'Create a new list and write into the list unless the list exist. default is true.' do |c| @create = c end
      opts.on '--[no-]rewrite-list', 'Rewrite the list. default is false.' do |rw| @rewrite = rw end
    end
  end

  def __main__ *argv
    @mlname ||= 'main'
    @mode ||= 'public'
    @desc ||= 'main list auto-created by TwitterUtils. https://github.com/pasberth/TwitterUtils'
    get_or_set :@force, false
    get_or_set :@create, true
    get_or_set :@rewrite, false

    if api.lists.lists.map(&:name).include? @bijection_list_name
      if @rewrite
      end
    elsif @create
      list = api.list_create @mlname, :mode => @mode, :description => @desc
      following_ids = api.friend_ids.collection
      following_ids.each_slice 100 do |ids|
        retry_times = 5
        begin
          api.list_add_members @mlname, ids
        rescue Twitter::Error::BadGateway
          (retry_times -= 1; retry) if retry_times > 0
        end
      end
      puts "New main list '#{list.full_name}' created. #{following_ids.count} users."
    end
  end
end
end
