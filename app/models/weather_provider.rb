class WeatherProvider < Sequel::Model
  one_to_many :weather_archives

  def self.find_or_initialize_from_weather_data(wd)
    weather_provider_search_hash = { name: wd.provider }

    weather_provider = self.where(weather_provider_search_hash).first
    weather_provider = new(weather_provider_search_hash) if weather_provider.nil?
    weather_provider.save
    weather_provider
  end
end
