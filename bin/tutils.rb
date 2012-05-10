#!/usr/bin/env ruby

# for testing
$:.unshift File.join(File.dirname(__FILE__), '/../lib')

require 'twitter_utils'
TwitterUtils::Commands::Run.run