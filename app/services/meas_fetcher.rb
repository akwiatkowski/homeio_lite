class MeasFetcher
  def initialize
    @meas_cache_storages = Hash.new
    @meas_types = Hash.new
    MEAS_TYPES.each do |definition|
      name = definition[:name]
      @meas_cache_storages[name] = MeasCacheStorage.new(name)
      @meas_cache_storages[name].definition = definition

      c = MeasType.where(name: name).first
      c = MeasType.new(name: name) if c.nil?
      c.save
      @meas_types[name] = c
    end
  end

  def make_it_so
    loop do
      @meas_cache_storages.values.each do |meas_cache_storage|
        meas_cache_storage.fetch
      end
      sleep 0.2
    end
  end
end