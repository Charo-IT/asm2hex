#!/usr/bin/env ruby
require "open3"

def parseargs(args)
  options = {
    filename: nil,
    escaped_string: false,
    bit: 64,
  }

  i = 0
  while args[i]
    if args[i] == "-e"
      options[:escaped_string] = true
    elsif args[i] == "-b"
      if !["32", "64"].include?(args[i + 1])
        return nil
      end
      options[:bit] = args[i + 1].to_i
      i += 1
    elsif !options[:filename]
      options[:filename] = args[i]
    else
      return nil
    end
    i += 1
  end

  if !options[:filename]
    return nil
  end

  options
end

options = parseargs(ARGV)
if !options
  warn "Usage: asm2hex [options] filename"
  warn
  warn "options:"
  warn "  -e: print escaped shellcode"
  warn "  -b bit: 32 or 64 (default is 64bit)"
  exit true
end

output, status = Open3.capture2("nasm -f elf#{options[:bit]} -o /dev/null -l /dev/stdout #{options[:filename]}")

if status != 0
  exit false
end

puts output
puts

result = ""
output.each_line{|l|
  m = l.match(/^ *\d+ [0-9A-F]+ ([0-9A-F]+)-? +.*$/)
  if m
    result << m.captures[0]
  end
}
puts "code length: #{result.length / 2}"
if [result].pack("H*").include?("\0")
  puts "[!] contains null byte"
end

if options[:escaped_string]
  puts result.downcase.scan(/../).map{|a| '\x' + a}.join
else
  puts result.downcase
end
