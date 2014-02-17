class @Dashboard
  constructor: ->
    @getPayload()

  getPayload: () ->
    $.getJSON "/dashboard/payload", (data) =>
      localStorage.setItem("homeio_lite_meas_types", data["meas_types"])
      localStorage.setItem("homeio_lite_action_types", data["action_types"])
      @onGetMeasTypes(data["meas_types"])
      @onGetActionTypes(data["action_types"])

  onGetMeasTypes: (types) ->
    for meas_type in types
      name = meas_type["meas_type"]["name"]
      $("#meas_types").append("<a class=\"pure-button meas-button\" data-meas-name=\"" + name + "\" href=\"#\" id=\"" + name + "\">" + name + "</a>")
    $("#meas_types .meas-button").click (event) =>
      @onMeasButtonClick(event)
      return false

  onGetActionTypes: (types) ->
    for action_type in types
      name = action_type["action_type"]["name"]
      $("#action_types").append("<a class=\"pure-button action-button\" data-action-name=\"" + name + "\" href=\"#\" id=\"" + name + "\">" + name + "</a>")
    $("#action_types .action-button").click (event) =>
      @onActionButtonClick(event)
      return false

  onMeasButtonClick: (event) ->
    flot_options =
      series:
        lines:
          show: true
        points:
          show: true
    legend:
      show: true

    name = $(event.currentTarget).attr("data-meas-name")
    $.getJSON "/measurements/" + name, (data) ->
      buffer = data["buffer"]
      coefficient_linear = data["meas_cache"]["coefficient_linear"]
      coefficient_offset = data["meas_cache"]["coefficient_offset"]

      for d in buffer
        d[1] = ( d[1] + coefficient_offset ) * coefficient_linear

      $.plot "#chart", [buffer], flot_options

  onActionButtonClick: (event) ->
    name = $(event.currentTarget).attr("data-action-name")
    $.post "/actions/" + name + "/execute", (data) ->
      console.log data
