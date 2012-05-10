module TwitterUtils
  module Commands
    include TwitterUtils
    require 'twitter_utils/commands/base'
    #require 'twitter_utils/commands/mkml'
    require 'twitter_utils/commands/upimg'
    require 'twitter_utils/commands/mkbijection'
    #require 'twitter_utils/commands/followall'
    require 'twitter_utils/commands/run'
  end
end