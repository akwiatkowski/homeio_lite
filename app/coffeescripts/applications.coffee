@Measurement =
  plotMeasurement: ->
    $.getJSON "/measurements/batt_u", (data) ->
      $.plot "#chart", [data]
    return

