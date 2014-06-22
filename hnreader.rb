
require 'launchy'
require 'pry'
require 'rainbow'
require 'ruby-hackernews'

include RubyHackernews

def show_entries
  @entries.each_with_index do |entry, i|
    print Rainbow("%02d" % (i+1)).white + '> '
    print Rainbow(" [%03d] " % entry.voting.score).green
    puts Rainbow(entry.link.title).yellow
  end
end

def help
  puts 'h - show help options'
  puts 'launch - open all links'
  puts 'open - open selected. eg. open 1 5 7'
  puts 'x - exit'
end

def filter
  @entries = @all_entries.select { |e| e.voting.score > 100 }
end

def launch
  @entries.each { |e| open_in_browser(e) }
end

def open_in_browser(e)
  Launchy.open(e.link.href)
  Launchy.open(e.comments_url)
end

def open_selected
  list = @response.split
  list.shift
  list.each { |x| open_in_browser(@entries[x.to_i-1]) }
end

@all_entries = Entry.all
@entries = @all_entries

show_entries

while true
  print '> '
  @response = gets.chomp
  case @response
  when 'h' then help
  when 'launch' then launch
  when /^open/ then open_selected
  when 'x' then exit
  end
end
