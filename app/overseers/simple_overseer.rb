class SimpleOverseer
  def initialize(meas_name, action_name, type, threshold, avg_from)
    @meas_cache_storage = MeasCacheStorage[meas_name]
    @action_cache_storage = ActionCacheStorage[action_name]

    @typ = type
    @threshold = threshold
    @avg_from = avg_from
  end

  def check
    logger.debug "#{self.class.to_s} check, value #{value}"
  end

  def value
    @meas_cache_storage.avg_buffer_value(0, @avg_from)
  end
end