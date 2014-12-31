class WeatherMetarArchive < Sequel::Model
  plugin :timestamps

  many_to_one :city
  many_to_one :meas_type

  def weather_provider_id
    nil
  end

  def self.initialize_from_weather_data(wd)
    # use non-metar version
    return WeatherArchive.initialize_from_weather_data(wd) if false == wd.is_metar?

    city = City.find_or_initialize_from_weather_data(wd)

    weather_metar_archive_search_hash = {
      city_id: city.id,
      time_from: wd.time_from,
      time_to: wd.time_to
    }

    weather_metar_archive = where(weather_metar_archive_search_hash).first
    weather_metar_archive = new(weather_metar_archive_search_hash) if weather_metar_archive.nil?

    # store weather info
    weather_metar_archive.temperature = wd.temperature
    weather_metar_archive.wind = wd.wind
    weather_metar_archive.pressure = wd.pressure
    weather_metar_archive.rain_metar = wd.rain_metar
    weather_metar_archive.snow_metar = wd.snow_metar
    weather_metar_archive.raw = wd.metar_string

    weather_metar_archive
  end
end
