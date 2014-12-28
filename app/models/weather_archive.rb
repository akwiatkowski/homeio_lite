class WeatherArchive < Sequel::Model
  many_to_one :city
  many_to_one :weather_provider

  def self.create_from_weather_data(wd)
    # use metar version
    return WeatherMetarArchive.create_from_weather_data(wd) if wd.is_metar?

    city = City.find_or_initialize_from_weather_data(wd)
    weather_provider = WeatherProvider.find_or_initialize_from_weather_data(wd)

    weather_archive_search_hash = {
      city_id: city.id,
      weather_provider_id: weather_provider.id,
      time_from: wd.time_from,
      time_to: wd.time_to
    }

    weather_archive = where(weather_archive_search_hash).first
    weather_archive = new(weather_archive_search_hash) if weather_archive.nil?

    # store weather info
    weather_archive.temperature = wd.temperature
    weather_archive.wind = wd.wind
    weather_archive.pressure = wd.pressure
    weather_archive.rain = wd.rain
    weather_archive.snow = wd.snow

    weather_archive.save
    weather_archive
  end
end
