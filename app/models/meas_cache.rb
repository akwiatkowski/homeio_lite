class MeasCache < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes

  attribute :name
  unique :name
  index :name

  #MAX_BUFFER_SIZE = 200_000
  MAX_BUFFER_SIZE = 200

  def initialize(*args)
    @redis = Redis.new
    super(*args)
  end

  def redis_list_name
    return @redis_list if defined? @redis_list
    @redis_list = "homeio_#{self.name}_buffer"
  end

  def add_measurement(raw)
    if @redis.llen(redis_list_name) > MAX_BUFFER_SIZE
      @redis.rpoplpush(redis_list_name, raw)
    else
      @redis.lpush(redis_list_name, raw)
    end
  end

  def buffer(from, to)
    @redis.lrange(redis_list_name, from, to)
  end
end