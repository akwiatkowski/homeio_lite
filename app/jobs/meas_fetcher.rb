class MeasFetcher
  def initialize
    @meas_cache_storages = Hash.new
    MEAS_TYPES.each do |definition|
      name = definition[:name]
      @meas_cache_storages[name] = MeasCacheStorage.new(name, definition)
      # time is not stored in list
      @meas_cache_storages[name].clear_buffer
    end
  end

  def make_it_so
    loop do
      @meas_cache_storages.values.each do |meas_cache_storage|
        meas_cache_storage.fetch
      end
      sleep 0.1
    end
  end
end