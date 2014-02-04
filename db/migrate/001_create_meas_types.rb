Sequel.migration do
  up do
    unless table_exists?('meas_types')
      create_table :meas_types do
        primary_key :id
        String :name, size: 50
        String :unit
        timestamp :created_at
        timestamp :updated_at

        index :name
      end
    end
  end

  down do
    drop_table :meas_types
  end
end
