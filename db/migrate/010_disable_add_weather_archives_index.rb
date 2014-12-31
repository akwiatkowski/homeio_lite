Sequel.migration do
  up do
    alter_table :weather_archives do
      drop_index [:time_from, :time_to, :city_id, :weather_provider_id]
    end

  end

  down do
    alter_table :weather_archives do
      add_index [:time_from, :time_to, :city_id, :weather_provider_id]
    end
  end
end
