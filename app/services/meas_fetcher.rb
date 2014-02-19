class MeasFetcher
  def initialize
    @meas_cache_storages = Hash.new
    @meas_archive_storages = Hash.new
    MEAS_TYPES.each do |definition|
      name = definition[:name]
      @meas_cache_storages[name] = MeasCacheStorage.new(name, definition)
      # time is not stored in list
      @meas_cache_storages[name].clear_buffer

      @meas_archive_storages[name] = MeasArchiveStorage[name]
      @meas_archive_storages[name].cache_storage = @meas_cache_storages[name]
    end
  end

  def make_it_so
    loop do
      @meas_cache_storages.values.each do |meas_cache_storage|
        meas_cache_storage.fetch
      end

      @meas_archive_storages.values.each do |meas_archive_storage|
        meas_archive_storage.archive
      end

      sleep 0.2
    end
  end
end