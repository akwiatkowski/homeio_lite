class MeasCache < Ohm::Model
  include Ohm::DataTypes
  include Ohm::Timestamps
  #include Ohm::Validations

  attribute :name
  unique :name
  index :name

  attribute :start_time, Type::Float
  attribute :command
  attribute :response_size, Type::Integer
  attribute :coefficient_linear, Type::Float
  attribute :coefficient_offset, Type::Float
  attribute :interval, Type::Float
  attribute :unit

  attribute :important, Type::Boolean

  #assert_present :name,
  #               :command,
  #               :response_size,
  #               :coefficient_linear,
  #               :coefficient_offset,
  #               :interval
end