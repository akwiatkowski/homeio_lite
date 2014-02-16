class ActionEvent < Sequel::Model
  many_to_one :action_type
end
