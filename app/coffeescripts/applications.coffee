class @Dashboard
  constructor: ->
    @getTypes()

  getTypes: () ->
    $.getJSON "/dashboard/payload", (data) =>
      localStorage.setItem("homeio_lite_types", data["types"])
      @onGetTypes(data["types"])

  onGetTypes: (types) ->
    for meas_type in types
      name = meas_type["type"]["name"]
      $("#types").append("<a class=\"pure-button meas-button\" data-meas-name=\"" + name + "\" href=\"#\" id=\"" + name + "\">" + name + "</a>")
    $("#types .meas-button").click (event) =>
      @onMeasButtonClick(event)

  onMeasButtonClick: (event) ->
    name = $(event.currentTarget).attr("data-meas-name")
    $.getJSON "/measurements/" + name, (data) ->
      buffer = data["buffer"]
      $.plot "#chart", [buffer]


