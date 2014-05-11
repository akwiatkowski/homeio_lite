require 'socket'

class HomeioBackendProtocol
  @@host = BACKEND_SERVER[:host]
  @@port = BACKEND_SERVER[:port]

  def self.c(meas_type, from, to)
    return nil if meas_type.to_s == "" or from.to_s == "" or to.to_s == ""

    s = TCPSocket.open(@@host, @@port)

    command = "#{meas_type};#{from};#{to};"
    s.puts command
    data_json = s.gets
    s.close

    data = JSON.parse(data_json)
    return data
  end
end