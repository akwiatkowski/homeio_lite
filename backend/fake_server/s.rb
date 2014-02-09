port = 2002
#response = 48.chr + 57.chr
response = "09"

require "socket"
server = TCPServer.open(2002)
loop do
  loop do
    client = server.accept
    line = client.gets

    puts "#{Time.now.to_s} - in '#{line.inspect}' out '#{response}'"

    client.write response
    client.close
  end
end