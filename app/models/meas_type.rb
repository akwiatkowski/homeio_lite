class MeasType < Sequel::Model
  plugin :timestamps

  one_to_many :meas_archives
end
