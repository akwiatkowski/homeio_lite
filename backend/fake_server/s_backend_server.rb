load 'config/backend/backend_server.rb'
require "socket"
require "json"

port = BACKEND_SERVER[:port]
initial_pool = 100
interval = 0.04

server = TCPServer.open(port)
puts "#{Time.now.to_s} opened backend fake server on port #{port}"

meas_types = Hash.new
last_times = Hash.new
first_times = Hash.new


loop do
  client = server.accept
  line = client.gets

  response = "{}"

  if line =~ /(\w+);(\d+);(\d+)/
    name = $1
    from = $2.to_i
    to = $3.to_i

    puts "from #{from} to #{to}"

    if meas_types[name].nil?
      meas_types[name] = Array.new
      meas_types[name] << rand(256)

      first_times[name] = Time.now.to_i - initial_pool * interval
    end

    enough = false
    while enough == false
      value = meas_types[name].last

      if value < 50
        value += 2
      elsif value < 90
        value += 1
      elsif value > (512 - 90)
        value -= 1
      elsif value > (512 - 50)
        value += 2
      end

      rest = rand(100) % 6
      if rest == 2 or rest == 3
        # nothing
      else
        value += 6 - rest
      end

      # some more funny stuff
      value += (3.0 * Math.sin(meas_types[name].size.to_f / 10.0)).to_i

      value = 0 if value < 0
      value = 512 if value > 512

      meas_types[name] << value

      enough = true if meas_types[name].size > 100
    end

    last_times[name] = Time.now.to_i

    fixed_to = meas_types[name].size - from - 1
    fixed_from = meas_types[name].size - to - 1

    puts "fixed_from #{fixed_from} fixed_to #{fixed_to}"

    response = {
      status: 0,
      meas_type: name,
      last_time: last_times[name],
      first_time: first_times[name],
      interval: interval,
      count: meas_types[name].size,
      data: meas_types[name][fixed_from..fixed_to].reverse
    }.to_json

  end

  puts "#{Time.now.to_s} - in '#{line.inspect}' out '#{response}'"

  client.write response
  client.close
end
