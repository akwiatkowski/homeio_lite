child @meas_types => :types do
  attribute :name, :start_time, :coefficient_linear, :coefficient_offset, :interval

  node :value do |m|
    @measurements[m.name]
  end

end
