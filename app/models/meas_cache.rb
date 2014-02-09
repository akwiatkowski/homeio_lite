class MeasCache < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes

  attribute :name
  unique :name
  index :name
end