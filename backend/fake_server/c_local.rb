host = "localhost"
#host = "192.168.0.2"
command = 1.chr + 2.chr + 't'

require "socket"
s = TCPSocket.open(host, 2002)
s.puts command
line = s.gets
raw = line.unpack("S").first
puts "#{Time.now.to_s} - out '#{command.inspect}' in '#{line.inspect}' = #{raw}"
s.close