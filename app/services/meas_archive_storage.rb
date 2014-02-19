class MeasArchiveStorage
  def self.[](name)
    new(name)
  end

  attr_reader :name, :meas_archive, :cache_storage

  def initialize(name)
    @name = name
    # false - has no real connection to last meas cache time, has to use redis
    # true - not needed redis, faster
    @real_cache = false
    @cache_storage = MeasCacheStorage[self.name]

    prepare_ohm

    @meas_type = MeasType.where(name: name).first
    @meas_type = MeasType.new(name: name) if @meas_type.nil?
    @meas_type.save

    @buffer = nil

    @last_time = Time.now
    @last_value = nil
  end

  def cache_storage=(_mc)
    @real_cache = true
    @cache_storage = _mc

    prepare_ohm
  end

  def prepare_ohm
    @ohm = @cache_storage.ohm
    @archive_min_time = @ohm.archive_min_time
    @archive_max_time = @ohm.archive_max_time
    @archive_significant = @ohm.archive_significant
  end

  def archive
    buffer

    if archive?
      archive!
    else
      nil
    end
  end

  def buffer_index
    i = @cache_storage.buffer_index_for_time_redis(@last_time.to_f)
    #logger.debug "index #{i}"
    return i
  end

  def buffer
    @buffer = @cache_storage.buffer_values_time(0, buffer_index)
  end

  def archive?
    to_archive = nil

    time_offset = Time.now.to_f - @last_time.to_f

    if time_offset < @archive_min_time
      to_archive = false
      #logger.debug "no archive - too often"
    elsif time_offset >= @archive_max_time
      to_archive = true
      #logger.debug "archive - interval too long"
    elsif @last_value.nil?
      to_archive = true
      #logger.debug "archive - initial"
    elsif (@last_value - avg_buffer_value).abs > @archive_significant
      to_archive = true
      #logger.debug "archive - value change"
    end

    to_archive
  end

  def archive!
    if @buffer.nil?
      buffer
    end
    return nil if @buffer.nil? or @buffer.size == 0

    t = Time.now.to_f
    v = self.value

    object = {
      meas_type: @meas_type,
      time_from: @last_time,
      time_to: Time.now,
      value: v
    }

    @last_time = t
    @last_value = v

    return object
  end

  def clear_buffer
    @buffer = nil
  end

  def avg_buffer_value
    @buffer.collect { |b| b[1] }.inject { |sum, el| sum + el }.to_f / @buffer.size
  end

  def value
    avg_buffer_value
  end

  def time_from
    @last_time
  end

  def time_to
    Time.now
  end

end
