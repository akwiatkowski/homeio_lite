class WeatherArchive < Sequel::Model
  many_to_one :city
  many_to_one :weather_provider
end
