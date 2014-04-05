require 'socket'

class IoServerProtocol
  @@host = IO_SERVER[:host]
  @@port = IO_SERVER[:port]

  def self.c(command, response_size)
    return nil if command.to_s == "" or response_size.to_s == ""

    s = TCPSocket.open(@@host, @@port)

    # <count of command bytes> <count of response bytes> <command bytes>
    str = command.size.chr + response_size.to_i.chr + command.to_s
    s.puts str
    data = s.gets
    s.close

    int_data = 0
    data.each_byte do |b|
      # puts b
      int_data *= 256
      int_data += b
    end

    return int_data
  end
end