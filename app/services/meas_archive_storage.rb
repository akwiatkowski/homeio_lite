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
    @ohm = @cache_storage.ohm

    @meas_archive = MeasType.where(name: name).first
    @meas_archive = MeasType.new(name: name) if @meas_archive.nil?
    @meas_archive.save

    @start_time = Time.now.to_f
  end

  def cache_storage=(_mc)
    @real_cache = true
    @cache_storage = _mc
    @ohm = @cache_storage.ohm
  end

  def archive
    if @real_cache
      i = @cache_storage.buffer_index_for_time(@start_time)
    else
      i = @cache_storage.buffer_index_for_time_redis(@start_time)
    end

    buffer = @cache_storage.buffer_values_time(0, i)

    # puts "*", i, buffer.size, buffer.inspect
  end

  def fresh_raws

  end

end
