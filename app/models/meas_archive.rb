class MeasArchive < Sequel::Model
  many_to_one :meas_type
end
