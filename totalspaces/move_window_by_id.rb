#!/usr/bin/env /usr/local/bin/ruby

require 'rubygems'
require 'totalspaces2'

#puts TotalSpaces2.move_window_to_space(84873, 16)
windows = TotalSpaces2.window_list
current_space = TotalSpaces2.current_space
main_display_id = TotalSpaces2.main_display[:display_id]
if !windows.empty?
  current_space_windows = windows.select {|window| window[:display_id] == main_display_id && window[:space_number] == current_space}
  front_window = current_space_windows[0]
  puts front_window[:window_id]
  puts TotalSpaces2.current_space
  puts TotalSpaces2.move_window_to_space(front_window[:window_id], TotalSpaces2.current_space - 1)
end

