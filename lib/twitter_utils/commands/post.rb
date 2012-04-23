require 'twitter_utils/commands/base'

module TwitterUtils::Commands

class Post < Base
  
  def option_parser
    opt = OptionParser.new
    opt.on('-m MSG') { |msg| @message = msg }
    opt
  end

  def __main__ *argv
    if @message
      api.update @message
    end
  end
end
end
