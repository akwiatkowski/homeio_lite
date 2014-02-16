class ActionCache < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Timestamps

  attribute :name
  unique :name
  index :name

  attribute :command
  attribute :response_ok, Type::Integer
  attribute :response_size, Type::Integer
end