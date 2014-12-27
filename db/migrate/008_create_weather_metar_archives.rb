Sequel.migration do
  up do
    unless table_exists?('weather_metar_archives')
      create_table :weather_metar_archives do
        primary_key :id

        timestamp :time_from
        timestamp :time_to

        Float :temperature
        Float :wind
        Float :pressure

        Fixnum :rain_metar
        Fixnum :snow_metar

        String :raw

        timestamp :created_at
        timestamp :updated_at

        foreign_key :city_id, :cities

        index [:time_from, :city_id]
      end
    end
  end

  down do
    drop_table :weather_metar_archives
  end
end
