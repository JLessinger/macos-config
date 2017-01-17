#!/usr/bin/env /usr/local/bin/ruby

FILE_PATH =  "~/Library/Application Support/TotalSpaces2/.spacenum.txt"

require 'rubygems'
require 'totalspaces2'

def save()
     File.open(File.expand_path(FILE_PATH), 'w') {
       |file| file.write("#{TotalSpaces2.current_space}")
       puts "writing"
    }
end

if __FILE__ == $PROGRAM_NAME
  save()
end
