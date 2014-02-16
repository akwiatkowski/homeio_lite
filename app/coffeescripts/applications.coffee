class @Dashboard
  constructor: ->
    @getPayload()

  getPayload: () ->
    $.getJSON "/dashboard/payload", (data) =>
      localStorage.setItem("homeio_lite_types", data["meas_types"])
      @onGetMeasTypes(data["meas_types"])

  getActionTypes: () ->


  onGetMeasTypes: (types) ->
    for meas_type in types
      name = meas_type["meas_type"]["name"]
      $("#types").append("<a class=\"pure-button meas-button\" data-meas-name=\"" + name + "\" href=\"#\" id=\"" + name + "\">" + name + "</a>")
    $("#types .meas-button").click (event) =>
      @onMeasButtonClick(event)

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
      $.plot "#chart", [buffer], flot_options


