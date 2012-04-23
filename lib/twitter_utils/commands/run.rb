require 'twitter_utils/commands/mkbijection'
require 'myoack'

module TwitterUtils::Commands

class Run < Base
  
  def __main__ *argv
    cmd = argv.shift
    commands[cmd].main(*argv)
  end
end
end
