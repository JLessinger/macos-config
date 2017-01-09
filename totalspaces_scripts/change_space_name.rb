#!/usr/bin/env /usr/local/bin/ruby

require 'rubygems'
require 'totalspaces2'

path_to_cocoa_dialog = "/Volumes/Macintosh_HD/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"

response = `"#{path_to_cocoa_dialog}" standard-inputbox --title "Change name for current space" --informative-text "Name for space #{TotalSpaces2.current_space}" --text "#{TotalSpaces2.name_for_space(TotalSpaces2.current_space)}"`
response = response.split("\n")

if response[0] == '2'
  puts "Clicked cancel. Exiting."
  exit
end

if response.length < 2
  puts "Did not provide name. Exiting."
  exit
end

name = response[1]
puts "Changing space name to " + name
TotalSpaces2.set_name_for_space(TotalSpaces2.current_space, name)


