class MeasCacheStorage
  #MAX_BUFFER_SIZE = 200_000
  MAX_BUFFER_SIZE = 200

  attr_reader :ohm, :redis, :redis_list_name, :name

  def initialize(name)
    @name = name
    @redis = Redis.new
    @redis_list_name = "homeio_#{name}_buffer"

    @ohm = MeasCache.find(name: name).first
    @ohm = MeasCache.new(name: name) if @ohm.nil?
    @ohm.save!
  end

  def add_measurement(raw)
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
