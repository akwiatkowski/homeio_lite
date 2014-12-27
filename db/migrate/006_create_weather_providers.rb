Sequel.migration do
  up do
    unless table_exists?('weather_providers')
      create_table :weather_providers do
        primary_key :id

        String :name

        timestamp :created_at
        timestamp :updated_at

        index [:name]
      end
    end
  end

  down do
    drop_table :weather_providers
  end
end
