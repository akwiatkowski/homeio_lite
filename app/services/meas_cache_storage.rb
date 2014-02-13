class MeasCacheStorage
  #MAX_BUFFER_SIZE = 200_000
  MAX_BUFFER_SIZE = 200

  attr_reader :ohm, :redis, :name, :definition,
              :redis_last_time_name, :redis_list_name

  def self.[](name)
    new(name)
  end

  def initialize(name, _def = nil)
    @name = name
    @redis = Redis.new
    @redis_list_name = "homeio_#{name}_buffer"
    @redis_last_time_name = "homeio_#{name}_last_time"

    @ohm = MeasCache.find(name: name).first
    if @ohm.nil?
      @ohm = MeasCache.new(name: name)
      @ohm.save
    end

    if _def
      @definition = _def
      @ohm.command = self.definition[:comm][:command]
      @ohm.command = @ohm.command.kind_of?(Array) ? @ohm.command.join : @ohm.command.to_s
      @ohm.response_size = self.definition[:comm][:response_size]
      @ohm.coefficient_linear = self.definition[:comm][:coefficient_linear]
      @ohm.coefficient_offset = self.definition[:comm][:coefficient_offset]
      @ohm.interval = self.definition[:comm][:interval]
      @ohm.save
    end

  end

  ## Fetching, interval
  def from_last_added
    Time.now.to_f - self.last_time
  end

  def interval
    @ohm.interval
  end

  def command
    @ohm.command
  end

  def response_size
    @ohm.response_size
  end

  def coefficient_linear
    @ohm.coefficient_linear
  end

  def coefficient_offset
    @ohm.coefficient_offset
  end


  def fetchable?
    return true if self.last_time.nil? # first fetch
    from_last_added > interval
  end

  def fetch
    puts fetchable?
    fetch! if fetchable?
  end

  def fetch!
    raw = IoServerProtocol.c(self.command, self.response_size)
    add_measurement(raw)
  end

  def redis_last_time
    t = redis.get(redis_last_time_name)
    t = t.to_f unless t.nil?
    t
  end

  def last_time
    @last_time = redis_last_time unless defined? @last_time
    @last_time
  end

  def last_time!
    t = Time.now.to_f
    redis.set(redis_last_time_name, t)
    @last_time = t
  end

  def add_measurement(raw)
    last_time!

    if redis.llen(redis_list_name) > MAX_BUFFER_SIZE
      redis.rpoplpush(redis_list_name, raw)
    else
      redis.lpush(redis_list_name, raw)
    end
  end

  def buffer(from, to)
    redis.lrange(redis_list_name, from, to)
  end

  def clear_buffer
    redis.ltrim(redis_list_name, 0, 0)
  end

  def raw_to_value(raw)

  end

  # Buffer helpers
  # TODO fix axes
  def buffer_raw_time(from, to)
    i = -1
    buffer(from, to).collect { |b| i += 1; [self.last_time - i * self.interval, b] }.reverse
  end

  def buffer_raw_relative_time(from, to)
    i = 0
    bs = buffer(from, to)
    bs.collect { |b| i += 1; [-i * self.interval, b] }.reverse
  end

  def buffer_values_relative_time(from, to)
    buffer_raw_relative_time(from, to).collect { |b| [b[0], b[1].to_f * coefficient_linear + coefficient_offset] }
  end


end
