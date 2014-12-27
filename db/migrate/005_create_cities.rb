Sequel.migration do
  up do
    unless table_exists?('cities')
      create_table :cities do
        primary_key :id

        String :name
        String :country
        String :metar

        Float :lat
        Float :lon

        Float :calculated_distance

        TrueClass :logged_metar
        TrueClass :logged_weather

        index [:name]
        index [:name, :country]
      end
    end
  end

  down do
    drop_table :cities
  end
end
