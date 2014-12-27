class WeatherProvider < Sequel::Model
  one_to_many :weather_archives
end
