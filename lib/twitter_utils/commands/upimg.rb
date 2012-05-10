require 'twitter_utils/commands/mkbijection'
require 'myoack'

module TwitterUtils::Commands

class Upimg < Base
  
  parameter 'PATH', 'image path of the new icon.'

  def execute
    if File.exist? path
      api.update_profile_image File.new(path)
      puts "Profile image updated successful."
    else
      puts "#{path}: No such file or directory"
    end
  end
end
end
