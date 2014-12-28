class WeatherFetchJob
  WEATHER_YML_PATH = Padrino.root('config', 'backend', "weather.yml")

  def initialize
    raise "#{WEATHER_YML_PATH} not exists" unless File.exists?(WEATHER_YML_PATH)
    @cities = YAML::load(File.open(WEATHER_YML_PATH))
  end

  def make_it_loop
    loop do
      make_it_so
      sleep 60
    end
  end

  def make_it_so
    data = WeatherFetcher::Fetcher.fetch(@cities)
    data.each do |d|
      weather_archive = WeatherArchive.create_from_weather_data(d)
    end
  end
end