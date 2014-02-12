class MeasCache < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Timestamps

  attribute :name
  unique :name
  index :name

  attribute :start_time, Type::Float
  attribute :command
  attribute :response_size, Type::Integer
  attribute :coefficient_linear, Type::Float
  attribute :coefficient_offset, Type::Float
  attribute :interval, Type::Float
end