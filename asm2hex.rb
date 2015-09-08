require "open3"

if ARGV.length != 1
  STDERR.puts "Usage: asm2hex filename"
  exit true
end

filename = ARGV[0]

output, status = Open3.capture2("nasm -f elf -o /dev/null -l /dev/stdout #{filename}")

if status != 0
  exit false
end

puts output
puts

result = ""
output.each_line{|l|
  m = l.match(/^ *\d+ [0-9A-F]+ ([0-9A-F]+) +.*$/)
  if m
    result << m.captures[0]
  end
}
puts "code length: #{result.length / 2}"
if [result].pack("H*").include?("\0")
  puts "[!] contains null byte"
end
puts result.downcase
