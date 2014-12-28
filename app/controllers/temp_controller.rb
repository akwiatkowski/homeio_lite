HomeIo::App.controller :measurements do
  get :show, map: "/meas_type_groups/1/latest.txt" do
    h = Hash.new
    m = MeasCacheStorage["batt_u"]
    d = m.buffer_values_time(0, 0)
    h[:time] = Time.at(d[0][0])
    h[:batt_u] = d[0][1]

    m = MeasCacheStorage["i_gen_batt"]
    d = m.buffer_values_time(0, 0)
    h[:i_gen_batt] = d[0][1]

    m = MeasCacheStorage["coil_1_u"]
    d = m.buffer_values_time(0, 0)
    h[:coil_1_u] = d[0][1]

    m = MeasCacheStorage["outputs"]
    d = m.buffer_values_time(0, 0)
    h[:outputs] = d[0][1]


    string = "#{"%.1f" % h[:batt_u]} V | #{"%.1f" % h[:i_gen_batt]} A | #{"%.1f" % h[:coil_1_u]} V | #{"%.0f" % h[:outputs]}o |#{h[:time].strftime("%H:%M:%S")}"
    string
  end
end

