port = 2002
#response = 48.chr + 57.chr
#response = "09"

require "socket"
server = TCPServer.open(2002)
loop do
  loop do
    client = server.accept
    line = client.gets

    response_size = line[1].unpack("C").first
    internal_command = line[2]

    if response_size == 2
      if internal_command == 't'
        raw_data = 12345
      else
        max = 1023
        float_data = 0.5 + 0.5 * Math.sin(0.3 * Time.now.to_f * (0.1 + 't'.unpack("C").first.to_f / 400.0))
        raw_data = (max.to_f * float_data).round
      end

      response = [raw_data].pack("S")
    elsif response_size == 1
      raw_data = 0

      if internal_command == 'w'
        raw_data = 21
      elsif internal_command == 'W'
        raw_data = 20
      end

      response = [raw_data].pack("C")
    end


    puts "#{Time.now.to_s} - in '#{line.inspect}' out '#{response}'"

    client.write response
    client.close
  end
end