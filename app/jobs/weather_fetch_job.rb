class WeatherFetchJob
  WEATHER_YML_PATH = Padrino.root('config', 'backend', "weather.yml")

  def initialize
    raise "#{WEATHER_YML_PATH} not exists" unless File.exists?(WEATHER_YML_PATH)
    @cities = YAML::load(File.open(WEATHER_YML_PATH))
    if false
      result = WeatherFetcher::Fetcher.fetch(@cities)
    else
      prov = WeatherFetcher::Provider::WorldWeatherOnline.new(@cities)
      result = prov.fetch
    end
    puts result.to_yaml

  end

  def make_it_so
  end
end