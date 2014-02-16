Sequel.migration do
  up do
    unless table_exists?('action_types')
      create_table :action_types do
        primary_key :id

        String :name, size: 50

        timestamp :created_at
        timestamp :updated_at
      end
    end
  end

  down do
    drop_table :action_types
  end
end
