class City < Sequel::Model
  one_to_many :weather_archives
  one_to_many :weather_metar_archives

  def self.find_or_initialize_from_weather_data(wd)
    city_search_hash = wd.city_hash.clone
    city_search_hash.delete(:classes)
    city_search_hash[:lat] = city_search_hash[:coords][:lat].to_f
    city_search_hash[:lon] = city_search_hash[:coords][:lon].to_f
    city_search_hash.delete(:coords)

    city = self.where(city_search_hash).first
    city = new(city_search_hash) if city.nil?
    city
  end
end
