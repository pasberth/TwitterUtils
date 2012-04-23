#!/usr/bin/env ruby

# for testing
$:.unshift File.join(File.dirname(__FILE__), '/../lib')

require 'twitter_utils'
run = TwitterUtils::Commands::Run.new
run.main *ARGV