class MeasCacheStorage
  MAX_BUFFER_SIZE = 40_000

  attr_reader :ohm, :redis, :name, :definition,
              :redis_last_time_name, :redis_list_name

  def self.[](name)
    new(name)
  end

  def initialize(name, _def = nil)
    @name = name
    need_save = false
    @ohm = MeasCache.find(name: name).first
    if @ohm.nil?
      @ohm = MeasCache.new(name: name)
      need_save = true
    end

    if _def
      @definition = _def
      @ohm.command = self.definition[:comm][:command]
      @ohm.command = @ohm.command.kind_of?(Array) ? @ohm.command.join : @ohm.command.to_s
      @ohm.response_size = self.definition[:comm][:response_size]
      @ohm.coefficient_linear = self.definition[:comm][:coefficient_linear]
      @ohm.coefficient_offset = self.definition[:comm][:coefficient_offset]
      @ohm.interval = self.definition[:comm][:interval]
      @ohm.important = self.definition[:important]
      @ohm.unit = self.definition[:unit]

      @ohm.archive_min_time = self.definition[:archive][:min_time]
      @ohm.archive_max_time = self.definition[:archive][:max_time]
      @ohm.archive_significant = self.definition[:archive][:significant]

      need_save = true
    end

    if need_save
      @ohm.save
    end

  end

  ## Fetching, interval
  def from_last_added
    Time.now.to_f - self.last_time
  end

  def interval
    backend_interval
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

  def important
    @ohm.important
  end

  def unit
    @ohm.unit
  end

  def backend_fetch(from, to)
    HomeioBackendProtocol.c(self.name, from, to)
  end

  def backend_last_time
    _d = backend_fetch(0, 0)
    @last_time = _d["last_time"]
    @last_time
  end

  def backend_interval
    _d = backend_fetch(0, 0)
    @interval = _d["interval"]
    @interval
  end


  def last_time(_refresh = false)
    backend_last_time
    @last_time
  end

  def backend_buffer_length
    _d = backend_fetch(0, 0)
    _d["count"]
  end

  def buffer_length
    backend_buffer_length
  end

  def backend_buffer(from, to)
    _d = backend_fetch(from, to)
    if _d["data"].nil?
      return nil
    else
      _d["data"].select{|r| r}
    end
  end

  def buffer(from, to)
    backend_buffer(from, to)
  end

  def last
    r = buffer(0, 0)
    return nil if r.nil?
    r = r.first
    return nil if r.nil?
    r.to_i
  end

  def raw_to_value(raw)
    (raw.to_i + coefficient_offset).to_f * coefficient_linear.to_f
  end

  # Buffer helpers
  def buffer_raw_time(from, to)
    i = -1
    buffer(from, to).collect { |b| i += 1; [self.last_time - i * self.interval, b] }.reverse
  end

  def buffer_raw_relative_time(from, to)
    _to = self.last_time.to_f - Time.now.to_f
    i = 0
    bs = buffer(from, to)
    bs.collect { |b| i += 1; [-i * self.interval + _to, b] }.reverse
  end

  def buffer_values_relative_time(from, to)
    buffer_raw_relative_time(from, to).collect { |b| [b[0], raw_to_value(b[1])] }
  end

  def buffer_values_time(from, to)
    buffer_raw_time(from, to).collect { |b| [b[0], raw_to_value(b[1])] }
  end

  def avg_buffer_value(from, to)
    _b = buffer(from, to).collect { |b| raw_to_value(b) }
    _b.inject { |sum, el| sum + el }.to_f / _b.size
  end

  def buffer_index_for_time_redis(time)
    buffer_index_for_time(time, last_time)
  end

  def buffer_index_for_time(time, _last_time = self.last_time(true).to_f)
    _interval = self.interval
    if _last_time.nil? or time.nil? or _interval.nil?
      logger.error("MeasCacheStorage['#{self.name}'].buffer_index_for_time(#{time}, #{_last_time}) # interval #{_interval} ")
      return nil
    end

    i = (_last_time - time.to_f) / _interval
    i = 0 if i < 0.0
    i = i.ceil

    return i
  end

  def first_time
    last_time(true) - self.interval * self.buffer_length
  end

end
