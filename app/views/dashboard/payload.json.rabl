child @meas_types => :meas_types do
  attribute :name, :start_time, :coefficient_linear, :coefficient_offset, :interval

  node :value do |m|
    @measurements[m.name]
  end

end

child @action_types => :action_types do
  attribute :name
end
