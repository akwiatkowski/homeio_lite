class MeasCacheStorage
  #MAX_BUFFER_SIZE = 200_000
  MAX_BUFFER_SIZE = 200

  attr_reader :ohm, :redis, :redis_list_name, :name

  def self.[](name)
    new(name)
  end

  def initialize(name)
    @name = name
    @redis = Redis.new
    @redis_list_name = "homeio_#{name}_buffer"

    @ohm = MeasCache.find(name: name).first
    @ohm = MeasCache.new(name: name) if @ohm.nil?
    @ohm.save!
  end

  def definition=(_def)
    @definition = _def
    @ohm.definition = _def
    @ohm.save!
  end

  def definition
    @definition || @ohm.definition
  end

  ## Fetching, interval
  def from_last_added
    Time.now - @last_time
  end

  def interval
    @definition[:comm][:interval] rescue 4.0
  end

  def command
    @definition[:comm][:command].to_s
  end

  def response_size
    @definition[:comm][:response_size]
  end

  def fetchable?
    return true if @last_time.nil? # first fetch
    from_last_added > interval
  end

  def fetch
    fetch! if fetchable?
  end

  def fetch!
    raw = IoServerProtocol.c(self.command, self.response_size)
    add_measurement(raw)
  end

  def add_measurement(raw)
    @last_time = Time.now

    if redis.llen(redis_list_name) > MAX_BUFFER_SIZE
      redis.rpoplpush(redis_list_name, raw)
    else
      redis.lpush(redis_list_name, raw)
    end
  end

  def buffer(from, to)
    redis.lrange(redis_list_name, from, to)
  end
end
