class ActionCacheStorage
  MAX_BUFFER_SIZE = 200

  attr_reader :ohm, :redis, :name, :definition,
              :redis_last_time_name, :redis_list_name

  def self.[](name)
    new(name)
  end

  def initialize(name, _def = nil)
    @name = name
    @redis = Redis.new
    @redis_list_name = "homeio_#{name}_action_buffer"

    need_save = false
    @ohm = ActionCache.find(name: name).first
    if @ohm.nil?
      @ohm = ActionCache.new(name: name)
      need_save = true
    end

    if _def
      @definition = _def
      @ohm.command = self.definition[:comm][:command]
      @ohm.command = @ohm.command.kind_of?(Array) ? @ohm.command.join : @ohm.command.to_s
      @ohm.response_size = self.definition[:comm][:response_size]
      @ohm.response_ok = self.definition[:comm][:response_ok]
      need_save = true
    end

    if need_save
      @ohm.save
    end

  end

  def command
    @ohm.command
  end

  def response_size
    @ohm.response_size
  end

  def response_ok
    @ohm.response_ok
  end

  def execute!
    raw = IoServerProtocol.c(self.command, self.response_size)
    add_event(raw)
    @last_response = check_response(raw)
  end

  def check_response(raw)
    if self.response_ok.nil?
      { status: true, raw: raw, check: false }
    elsif self.response_ok == raw
      { status: true, raw: raw, check: true }
    else
      { status: false, raw: raw, check: false }
    end
  end

  def add_event(raw)
    time = Time.now.to_f

    if redis.llen(redis_list_name) > MAX_BUFFER_SIZE
      redis.rpoplpush(redis_list_name, time)
    else
      redis.lpush(redis_list_name, time)
    end
  end

  def buffer(from, to)
    redis.lrange(redis_list_name, from, to)
  end

  def last
    r = buffer(0, 0).first
    return nil if r.nil?
    r.to_f
  end

  def clear_buffer
    redis.ltrim(redis_list_name, 0, 0)
  end

  def raw_to_time(raw)
    Time.at(raw.to_f)
  end
end
