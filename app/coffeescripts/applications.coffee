class @Dashboard
  constructor: ->
    @getPayload()
    @dashboardInitials()

  getPayload: () ->
    $.getJSON "/dashboard/payload", (data) =>
      localStorage.setItem("homeio_lite_meas_types", data["meas_types"])
      localStorage.setItem("homeio_lite_action_types", data["action_types"])
      @onGetMeasTypes(data["meas_types"])
      @onGetActionTypes(data["action_types"])

  getPayloadUpdate: () ->
    $.getJSON "/dashboard/payload", (data) =>
      @onGetUpdatedMeasTypes(data["meas_types"])

  dashboardInitials: () ->
    $('.show-regular').click (event) =>
      @onToggleRegular(event)
    $('.update-payload').click (event) =>
      @getPayloadUpdate()

  onGetMeasTypes: (types) ->
    for meas_type in types
      @addMeasButton(meas_type)
    @onGetUpdatedMeasTypes(types)

    $("#meas_types .meas-button").click (event) =>
      @onMeasButtonClick(event)
      return false
    $("#meas_types .meas-button.regular").hide()

  onGetUpdatedMeasTypes: (types) ->
    for meas_type in types
      name = meas_type["meas_type"]["name"]
      value = (meas_type["meas_type"]["value"] + meas_type["meas_type"]["coefficient_offset"]) * meas_type["meas_type"]["coefficient_linear"]
      unit = meas_type["meas_type"]["unit"]
      tag = $('[data-meas-name="' + name + '"] .meas-value')
      value_content = value.toFixed(2) + " " + unit
      tag.html(value_content)
    $(".payload-time").html()

  addMeasButton: (meas_type) ->
    name = meas_type["meas_type"]["name"]
    important = meas_type["meas_type"]["important"]
    value = (meas_type["meas_type"]["value"] + meas_type["meas_type"]["coefficient_offset"]) * meas_type["meas_type"]["coefficient_linear"]
    unit = meas_type["meas_type"]["unit"]

    #content = "<span class=\"meas-value\">" + value.toFixed(2) + " " + unit + "</span>"
    content = "<span class=\"meas-value\"></span>"
    content += "<span class=\"meas-name\">" + name + "</span>"
    s = "<div class=\"pure-button meas-button"
    if important
      s += " important"
    else
      s += " regular"
    s += "\" data-meas-name=\"" + name + "\" href=\"#\" id=\"" + name + "\">" + content + "</div>"
    $("#meas_types").append(s)

  addActionButton: (name, important) ->
    s = "<div class=\"pure-button action-button"
    if important
      s += " important"
    else
      s += " regular"
    s += "\" data-action-name=\"" + name + "\" href=\"#\" id=\"" + name + "\">" + name + "</div>"
    $("#action_types").append(s)

  onGetActionTypes: (types) ->
    for action_type in types
      name = action_type["action_type"]["name"]
      important = action_type["action_type"]["important"]
      @addActionButton(name, important)
    $("#action_types .action-button").click (event) =>
      @onActionButtonClick(event)
      return false
    $("#action_types .action-button.regular").hide()

  onMeasButtonClick: (event) ->
    tag = $(event.currentTarget)
    name = tag.attr("data-meas-name")
    @getMeasDataAndDrawChart(name, 0)

  createMeasPaginationButton: (name, page) ->
    $("#chart-pagination").html("")
    list = [5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5]
    for i of list
      i_current = 5 - parseInt(i)
      i_page = i_current + parseInt(page)
      if i_page >= 0
        if i_current == 0
          klass_sufix = " current-pagination-button"
        else
          klass_sufix = ""
        button = "<div class=\"pure-button meas-pagination-button" + klass_sufix + "\" data-meas-name=\"" + name + "\" data-meas-page=\"" + i_page + "\">" + i_page + "</div>"
        $("#chart-pagination").append(button)

    $(".meas-pagination-button").click (event) =>
      tag = $(event.currentTarget)
      name = tag.attr("data-meas-name")
      page = tag.attr("data-meas-page")
      @getMeasDataAndDrawChart(name, page)

  afterGetMeasDataAndDrawChart: (name) ->
    $(".meas-button").removeClass "current-meas"
    $('.meas-button[data-meas-name="' + name + '"]').addClass "current-meas"

  getMeasDataAndDrawChart: (name, page) ->
    flot_options =
      series:
        lines:
          show: true
          fill: true
        points:
          show: false

    legend:
      show: true


    $.getJSON "/measurements/" + name + "?page=" + page, (data) =>
      buffer = data["buffer"]
      coefficient_linear = data["meas_cache"]["coefficient_linear"]
      coefficient_offset = data["meas_cache"]["coefficient_offset"]
      interval = data["meas_cache"]["interval"]
      last_time = data["meas_cache"]["last_time"]
      current_time = ( (new Date).getTime() / 1000.0 )
      time_offset = last_time - current_time - page * interval * buffer.length

      # time ranges
      $("#time-from").html(data["range"]["time_from"])
      $("#time-to").html(data["range"]["time_to"])

      new_data = []
      i = 0

      for d in buffer
        x = -1 * i * interval + time_offset
        y = ( parseFloat(d) + coefficient_offset ) * coefficient_linear

        new_d = [x, y]
        new_data.push new_d
        i += 1

      $("#chart-info").html("<strong>" + buffer.length + "</strong> measurements")
      if buffer.length > 0
        time_range = new_data[0][0] - new_data[new_data.length - 1][0]
        $("#chart-info").html( $("#chart-info").html() + ", " + "<strong>" + time_range + "</strong> seconds")
        $("#chart-info").html( $("#chart-info").html() + ", " + "<strong>" + Math.round(-1 * time_offset) + "</strong> seconds ago")

      new_data =
        data: new_data
        color: "#55f"

      $.plot "#chart", [new_data], flot_options
      @afterGetMeasDataAndDrawChart(name)
      @createMeasPaginationButton(name, page)

  onActionButtonClick: (event) ->
    tag = $(event.currentTarget)
    name = tag.attr("data-action-name")
    url = "/actions/" + name + "/execute"
    $.ajax
      type: "POST"
      url: url
      dataType: "json"
      success: (data) ->
        execution_status = data["result"]["status"]
        if execution_status == true
          tag.addClass("button-success")
          setTimeout (->
            tag.removeClass("button-success")
          ), 400
        else
          tag.addClass("button-error")
          setTimeout (->
            tag.removeClass("button-error")
          ), 400


  onToggleRegular: (event) ->
    tag = $(event.currentTarget)
    show_all = tag.attr("data-show-all")

    if show_all == "true"
      tag.attr("data-show-all", false)
      tag.html("Only important")
      $('.meas-button.regular').hide()
      $('.action-button.regular').hide()
    else
      tag.attr("data-show-all", true)
      tag.html("Show all")
      $('.meas-button.regular').show()
      $('.action-button.regular').show()

    console.log show_all
    return false
