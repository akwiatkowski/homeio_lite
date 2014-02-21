class SimpleOverseer
  attr_reader :threshold, :type

  def initialize(meas_name, action_name, type, threshold, avg_from)
    @meas_cache_storage = MeasCacheStorage[meas_name]
    @action_cache_storage = ActionCacheStorage[action_name]

    @typ = type
    @threshold = threshold
    @avg_from = avg_from
    @type = type

    if type.to_s == "higher"
      @hit = Proc.new do
        higher_hit?
      end
    elsif type.to_s == "lower"
      @hit = Proc.new do
        lower_hit?
      end
    else
      @hit = nil
    end


  end

  def check
    _hit = hit?
    logger.debug "#{self.class.to_s} check, value #{value} #{type} #{threshold}, hit #{_hit}"
    if _hit
      execute!
    end
  end

  def value
    _v = @meas_cache_storage.avg_buffer_value(0, @avg_from)
    return _v
  end

  def lower_hit?
    self.value <= self.threshold
  end

  def higher_hit?
    self.value >= self.threshold
  end

  def hit?
    @hit.call
  end

  def execute!
    @action_cache_storage.execute!
  end
end