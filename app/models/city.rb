class City < Sequel::Model
  one_to_many :weather_archives
  one_to_many :weather_metar_archives
end
