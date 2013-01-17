require 'selenium-webdriver'
load 'walker.rb'

if ARGV.length != 0
  puts "Usage: ruby runner.rb <some URL>"
  exit
end

address = ARGV[0]
walker = new Walker address
