class MeasArchiveStorage
  def self.[](name)
    new(name)
  end

  attr_reader :name, :meas_archive

  def initialize(name)
    @name = name
    @cache_storage = MeasCacheStorage[self.name]
    @ohm = @cache_storage.ohm

    @meas_archive = MeasType.where(name: name).first
    @meas_archive = MeasType.new(name: name) if @meas_archive.nil?
    @meas_archive.save

    @start_time = Time.now.to_f
  end

  def archive

  end
end
