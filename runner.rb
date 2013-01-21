require 'selenium-webdriver'
require_relative 'lib/walker'

if ARGV.length == 0
  puts "Usage: ruby runner.rb <some URL>"
  exit
end

address = ARGV[0]
walker = Walker.new address
puts walker.take_action
