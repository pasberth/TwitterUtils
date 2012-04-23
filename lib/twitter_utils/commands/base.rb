require 'active_support/core_ext/string'
require 'myoack'
require 'optparse'
require 'twitter'
require 'twitter_utils/commands'

module TwitterUtils::Commands

class Base
    
  attr_accessor :command_name
  attr_accessor :option_parser

  def main *argv
    option_parser.respond_to? :parse! and option_parser.parse! argv
    __main__ *argv
  end

  def __main__ *argv
    raise NotImplementedError, "not implemented `main' for #{self}:#{self.class}"
  end
  
  def api
    cfg = Myoack::Config.require_config(:twitter)
    Twitter.configure do |config|
      config.consumer_key = cfg.consumer_key
      config.consumer_secret = cfg.consumer_secret
      config.oauth_token = cfg.access_token
      config.oauth_token_secret = cfg.access_token_secret
    end
  end
  
  def commands
    @commands ||= (Hash[*Base.commands.flat_map { |cmdid, cmdclass|
      [cmdid, cmdclass.new]
    }])
  end

  @@commands = Hash.new do |cmdtable, id|
    cmdid = id.to_s.underscore
    if cdmtable.key? cmdid
      cmdtable[cmdid]
    else
      nil
    end
  end

  def self.commands
    @@commands
  end
  
  def self.cmdidformat base_id
    raise "cmdid must not be nil" unless base_id
    cmdid = base_id.to_s
    cmdid.gsub! /^#{Regexp.quote TwitterUtils::Commands.name + '::'}/, ''
    cmdid = cmdid.to_s.underscore
    cmdid
  end
  
  def self.define_command id, cmdclass
    return false unless id
    cmdid = cmdidformat(id)
    Base.commands[cmdid] = cmdclass
    true
  end

  def self.inherited cmdclass
    define_command cmdclass.name, cmdclass
  end
end
end