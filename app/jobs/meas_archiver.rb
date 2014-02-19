class MeasArchiver
  def initialize
    @meas_archive_storages = Hash.new
    @meas_pool = Array.new
    MEAS_TYPES.each do |definition|
      name = definition[:name]
      @meas_archive_storages[name] = MeasArchiveStorage[name]
    end
  end

  def make_it_so
    loop do
      @meas_archive_storages.values.each do |meas_archive_storage|
        object = meas_archive_storage.archive
        unless object.nil?
          @meas_pool << object
          puts "size #{@meas_pool.size}"
        end
      end

      sleep 0.2
    end
  end
end