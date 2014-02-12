class MeasCache < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Timestamps

  attribute :name
  unique :name
  index :name

  attribute :interval, Type::Float
  attribute :start_time, Type::Float

  attribute :definition, Type::Hash
end