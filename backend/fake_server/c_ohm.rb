require 'ohm'
require 'ohm/contrib'
require '../../app/models/meas_cache'
require "socket"

class FakeBackendClient
  attr_accessor :host, :port, :command

  def initialize
    @host = "localhost"
    @port = 2002
    @command = 1.chr + 2.chr + 't'

    @store = MeasCache.find(name: "test").first
    if @store.nil?
      @store = MeasCache.new
      @store.name = "test"
      @store.save
    end

    @redis = Redis.new
  end

  def get
    s = TCPSocket.open(host, 2002)
    s.puts command
    line = s.gets
    raw = line.unpack("S").first
    puts "#{Time.now.to_s} - out '#{command.inspect}' in '#{line.inspect}' = #{raw}"
    s.close

    return raw
  end

  def store_ohm_array(_r)
    @store.on_get_measurement(_r)
    @store.save
    puts @store.buffer.size
  end

  def store(_r)
    puts @store.add_measurement(_r)
  end

  def bench
    loop do
      t = Time.now
      store(get)
      puts "TC #{Time.now - t}"
    end
  end
end

f = FakeBackendClient.new
#f.get
f.bench

