require 'twitter_utils/commands/mkbijection'
require 'myoack'

module TwitterUtils::Commands

class Upimg < Base
  
  def __main__ *argv
    path = argv.shift
    if File.exist? path
      api.update_profile_image File.new(path)
      puts "Profile image updated successful."
    else
      puts "#{path}: No such file or directory"
    end
  end
end
end
