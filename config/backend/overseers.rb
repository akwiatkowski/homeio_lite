OVERSEERS = [
  SimpleOverseer.new("batt_u", "start_total_brake", :higher, 50.0, 20),
  SimpleOverseer.new("batt_u", "output_2_on", :higher, 38.0, 30),
  SimpleOverseer.new("batt_u", "output_3_on", :higher, 42.5, 55),
  SimpleOverseer.new("batt_u", "output_2_off", :lower, 24.0, 30),
  SimpleOverseer.new("batt_u", "output_3_off", :lower, 34.5, 55),
]