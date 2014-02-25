class MeasArchiver
  POOL_SIZE = 100
  POOL_TIME_INTERVAL = 360.0

  def initialize
    @meas_archive_storages = Hash.new
    MEAS_TYPES.each do |definition|
      name = definition[:name]
      @meas_archive_storages[name] = MeasArchiveStorage[name]
    end

    clear_pool

    @files_path = Padrino.root('data', 'backup')
    FileUtils.mkdir_p(@files_path) unless File.exist?(@files_path)
  end

  def make_it_so
    loop do
      @meas_archive_storages.values.each do |meas_archive_storage|
        object = meas_archive_storage.archive
        unless object.nil?
          @meas_pool << object
          logger.info "size #{@meas_pool.size}"
        end
      end

      if (@meas_pool.size >= POOL_SIZE) or ((Time.now.to_f - @last_store_time.to_f) >= POOL_TIME_INTERVAL)
        store_in_db
        store_in_file
        clear_pool
      end

      sleep 2.0
    end
  end

  def store_in_db
    Sequel::Model.db.transaction do
      @meas_pool.each do |m|
        object = MeasArchive.new
        object.meas_type_id = m[:meas_type].id
        object.time_from = Time.at(m[:time_from].to_f)
        object.time_to = Time.at(m[:time_to].to_f)
        object.value = m[:value]
        object.save
      end
    end

    logger.info "Stored #{@meas_pool.size} in DB"
  end

  def store_in_file
    file_name = File.join(@files_path, "meas_#{Time.now.strftime("%Y_%m_%d")}.csv")
    exists = File.exist?(file_name)
    file = File.new(file_name, 'a')

    unless exists
      file.puts "meas_type; unix_time_from; unix_time_to; raw_value; value"
    end

    @meas_pool.each do |m|
      file.puts "#{m[:meas_type].name}; #{m[:time_from].to_f}; #{m[:time_to].to_f}; ; #{m[:value].to_f}"
    end

    file.close

    logger.info "Stored #{@meas_pool.size} in file #{file_name}"
  end


  def clear_pool
    @meas_pool = Array.new
    @last_store_time = Time.now
  end
end