require 'twitter_utils/commands/mkbijection'
require 'myoack'

module TwitterUtils::Commands

  class Run < Base
    subcommand 'upimg', 'update profile icon,', Upimg
    subcommand 'followall', 'follow simple filtered each user.', Followall
    subcommand 'mkbijection', 'make bijection list.', Mkbijection  
  end
end
