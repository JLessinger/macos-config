#!/usr/bin/env /usr/local/bin/ruby

require 'rubygems'
require 'totalspaces2'
require_relative 'save_current_space.rb'

def move()
  num = 0
  full_path = File.expand_path(FILE_PATH, "r")
  File.open(full_path) do |f|
    f.each_line do |line|
      num = Integer(line)
    end
  end
  if num > 0
    puts "#{num}"
    TotalSpaces2.move_to_space(num)
  end
end

if __FILE__ == $PROGRAM_NAME
  move()
end

