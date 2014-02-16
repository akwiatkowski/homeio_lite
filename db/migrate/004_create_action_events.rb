Sequel.migration do
  up do
    unless table_exists?('action_events')
      create_table :action_events do
        primary_key :id

        timestamp :time
        TrueClass :status

        foreign_key :action_type_id, :action_types
        index [:action_type_id, :time]
      end
    else
      alter_table :action_events do
        drop_column :other_info
        drop_column :error_status
        # at this moment it is removed
        drop_column :user_id
        drop_column :overseer_id

        add_column :status, TrueClass
      end
    end
  end

  down do
    drop_table :action_events
  end
end
