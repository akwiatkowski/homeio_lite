class MeasType < Sequel::Model
  one_to_many :meas_archives
end
