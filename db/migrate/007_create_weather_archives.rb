Sequel.migration do
  up do
    unless table_exists?('weather_archives')
      create_table :weather_archives do
        primary_key :id

        timestamp :time_from
        timestamp :time_to

        Float :temperature
        Float :wind
        Float :pressure
        Float :rain
        Float :snow

        timestamp :created_at
        timestamp :updated_at

        foreign_key :city_id, :cities
        foreign_key :weather_provider_id, :weather_providers

        index [:time_from, :city_id]
      end
    end
  end

  down do
    drop_table :weather_archives
  end
end