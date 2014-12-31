require 'colorize'

class WeatherFetchJob
  WEATHER_YML_PATH = Padrino.root('config', 'backend', "weather.yml")

  def initialize
    raise "#{WEATHER_YML_PATH} not exists" unless File.exists?(WEATHER_YML_PATH)
    @cities = YAML::load(File.open(WEATHER_YML_PATH))
  end

  def make_it_loop
    loop do
      make_it_so(verbose: true)
      sleep 3*3600
    end
  end

  def make_it_so(verbose: false)
    wf = WeatherFetcher::Fetcher.new
    wf.logger = Padrino.logger

    data = wf.fetch(@cities)
    data = data.collect do |d|
      WeatherArchive.initialize_from_weather_data(d)
    end

    data = data.uniq {|d| "#{d.class.to_s}#{d.city_id}#{d.weather_provider_id}#{d.time_from.to_i}#{d.time_to.to_i}"}

    Sequel::Model.db.transaction do
      data.each do |d|
        d.save
      end
    end

    if verbose
      verbose_results(data)
    end

    data
  end

  def verbose_results(data)
    v = Hash.new
    data.each do |d|
      v[d.city_id] ||= Hash.new
      v[d.city_id][:name] ||= d.city.name
      v[d.city_id][:counts] ||= Hash.new

      provider = defined?(d.weather_provider) ? d.weather_provider.name : "metar"
      v[d.city_id][:counts][provider] = v[d.city_id][:counts][provider].to_i + 1
    end

    v.keys.each do |cid|
      s = "#{v[cid][:name].red} - "
      s += v[cid][:counts].keys.collect { |p| "#{p.to_s.green}: #{v[cid][:counts][p].to_s.blue}" }.join(", ")

      puts s
    end
  end

end
