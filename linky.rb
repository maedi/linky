#!/usr/bin/ruby

require 'erb'
require 'set'

args = []
for i in 0 ... ARGV.length
  args << ARGV[i]
end

@dictionary = {}

File.foreach("lines.txt") do |line|
  tags = line.split('#')
  entry = tags.shift.rstrip

  tags.each do |tag|
    tag = tag.strip
    @dictionary[tag] = [] unless @dictionary.key? tag
    @dictionary[tag] << entry
  end
end

# HTML.

template = File.read('./template.html.erb')
result = ERB.new(template).result(binding)

File.open('linky.html', 'w+') do |f|
  f.write result
end

# Terminal.

chosen_entries = Set.new

args.each do |tag|
  next unless @dictionary.key? tag

  @dictionary[tag].each do |entry|
    chosen_entries << entry
  end
end

unless chosen_entries.empty?
  chosen_entries.each do |entry|
    puts "- #{entry}"
  end
end
