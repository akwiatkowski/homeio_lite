port = 2002
response = 48.chr + 57.chr
response = [12345].pack("S")

require "socket"
server = TCPServer.open(2002)
loop do
  loop do
    client = server.accept
    line = client.gets

    puts "#{Time.now.to_s} - in '#{line.inspect}' out '#{response}'"

    client.puts response
    client.close
  end
end