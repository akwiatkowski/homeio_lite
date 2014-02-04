Sequel.migration do
  up do
    unless table_exists?('meas_archives')
      create_table :meas_archives do
        primary_key :id

        Time :time_from
        Time :time_to

        Fixnum :raw
        Float :value

        foreign_key :meas_type_id, :meas_types
        index [:meas_type_id, :time_from]
      end
    else
      alter_table :meas_archives do
        drop_column :_time_from_ms
        drop_column :_time_to_ms
      end
    end
  end

  down do
    drop_table :meas_archives
  end
end
