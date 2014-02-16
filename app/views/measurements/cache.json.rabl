node(:buffer) {|n| @buffer}
node(:meas_cache) {
  attribute :name => @meas_cache.name, :coefficient_linear => @meas_cache.coefficient_linear, :coefficient_offset => @meas_cache.coefficient_offset
}