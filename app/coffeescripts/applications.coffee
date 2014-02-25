class @Dashboard
  constructor: ->
    @getPayload()
    @dashboardInitials()
    @autoRefresh()

  showWaitingSymbol: () ->
    $(".ajax-loader").show()

  hideWaitingSymbol: () ->
    $(".ajax-loader").hide()


  getPayload: () ->
    @showWaitingSymbol()
    $.getJSON "/dashboard/payload", (data) =>
      localStorage.setItem("homeio_lite_meas_types", data["meas_types"])
      localStorage.setItem("homeio_lite_action_types", data["action_types"])
      @onGetMeasTypes(data["meas_types"])
      @onGetActionTypes(data["action_types"])
      @hideWaitingSymbol()

  getPayloadUpdate: () ->
    @showWaitingSymbol()
    $.getJSON "/dashboard/payload", (data) =>
      @onGetUpdatedMeasTypes(data["meas_types"])
      @hideWaitingSymbol()

  dashboardInitials: () ->
    $('.show-regular').click (event) =>
      @onToggleRegular(event)
    $('.auto-refresh').click (event) =>
      @onToggleAutoRefresh(event)
    $('.update-payload').click (event) =>
      @getPayloadUpdate()

  autoRefresh: () ->
    setInterval =>
      is_refresh = parseInt($("input[name='auto_refresh']").val())
      if is_refresh == 1
        @getPayloadUpdate()
        @getMeasDataAndDrawChart()
    , 5000

  onGetMeasTypes: (types) ->
    for meas_type in types
      @addMeasButton(meas_type)
    @onGetUpdatedMeasTypes(types)

    $("#meas_types .meas-button").click (event) =>
      @onMeasNameButtonClick(event)
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
    if $("input[name='user_role']").val() == "admin"
      for action_type in types
        name = action_type["action_type"]["name"]
        important = action_type["action_type"]["important"]
        @addActionButton(name, important)
      $("#action_types .action-button").click (event) =>
        @onActionButtonClick(event)
        return false
      $("#action_types .action-button.regular").hide()

  onMeasNameButtonClick: (event) ->
    tag = $(event.currentTarget)
    name = tag.attr("data-meas-name")
    $("input[name='meas_name']").val(name)
    @getMeasDataAndDrawChart()

  onPageButtonClick: (event) ->
    tag = $(event.currentTarget)
    name = tag.attr("data-meas-name")
    $("input[name='meas_name']").val(name)
    @getMeasDataAndDrawChart()

  onZoomButtonClick: (event) ->
    tag = $(event.currentTarget)
    limit = tag.attr("data-meas-zoom")
    $("input[name='limit']").val(limit)
    @getMeasDataAndDrawChart()

  createMeasPaginationAndZoomButton: (name, page, limit, max_page) ->
    $("#chart-pagination").html("")
    half_size = 5
    i = -1 * half_size

    if page == max_page
      klass_sufix = " current-pagination-button"
    else
      klass_sufix = ""
    button = "<div class=\"pure-button meas-pagination-extreme meas-pagination-button" + klass_sufix + "\" data-meas-name=\"" + name + "\" data-meas-page=\"" + max_page + "\">" + max_page + "</div>"
    $("#chart-pagination").append(button)

    while i <= half_size
      i_current = -1 * parseInt(i)
      i++
      i_page = i_current + parseInt(page)
      if i_page >= 0
        if i_current == 0
          klass_sufix = " current-pagination-button"
        else
          klass_sufix = ""

        if i_page > 0 and i_page < max_page
          button = "<div class=\"pure-button meas-pagination-button" + klass_sufix + "\" data-meas-name=\"" + name + "\" data-meas-page=\"" + i_page + "\">" + i_page + "</div>"
          $("#chart-pagination").append(button)

    if page == 0
      klass_sufix = " current-pagination-button"
    else
      klass_sufix = ""
    button = "<div class=\"pure-button meas-pagination-extreme meas-pagination-button" + klass_sufix + "\" data-meas-name=\"" + name + "\" data-meas-page=\"" + 0 + "\">" + 0 + "</div>"
    $("#chart-pagination").append(button)

    $(".meas-pagination-button").click (event) =>
      tag = $(event.currentTarget)
      page = tag.attr("data-meas-page")
      $("input[name='page']").val(page)
      @getMeasDataAndDrawChart()

    $("#chart-zoom").html("")
    limits = [50, 100, 200, 500, 1000, 2000]
    console.log $("input[name='user_role']").val() == "admin", $("input[name='user_role']").val()
    if $("input[name='user_role']").val() == "admin"
      limits = limits.concat [5000, 10000, 20000, 50000]

    for i_limit in limits
      if limit == i_limit
        klass_sufix = " current-zoom-button"
      else
        klass_sufix = ""
      button = "<div class=\"pure-button meas-zoom-button" + klass_sufix + "\" data-meas-name=\"" + name + "\" data-meas-zoom=\"" + i_limit + "\">" + i_limit + "</div>"
      $("#chart-zoom").append(button)

    $(".meas-zoom-button").click (event) =>
      tag = $(event.currentTarget)
      i_limit = tag.attr("data-meas-zoom")
      $("input[name='limit']").val(i_limit)
      @getMeasDataAndDrawChart()

    $("#chart-smooth").html("")
    smooths = [0, 1, 2, 3, 5, 10, 20]
    current_smooth = parseInt($("input[name='smooth']").val())

    for i_smooth in smooths
      if current_smooth == i_smooth
        klass_sufix = " current-smooth-button"
      else
        klass_sufix = ""
      button = "<div class=\"pure-button meas-smooth-button" + klass_sufix + "\" data-meas-name=\"" + name + "\" data-meas-smooth=\"" + i_smooth + "\">" + i_smooth + "</div>"
      $("#chart-smooth").append(button)

    $(".meas-smooth-button").click (event) =>
      tag = $(event.currentTarget)
      i_smooth = tag.attr("data-meas-smooth")
      $("input[name='smooth']").val(i_smooth)
      @getMeasDataAndDrawChart()


  afterGetMeasDataAndDrawChart: (name) ->
    $(".meas-button").removeClass "current-meas"
    $('.meas-button[data-meas-name="' + name + '"]').addClass "current-meas"

  averageData = (chart_data, factor) ->
    i = undefined
    j = undefined
    x = undefined
    y = undefined
    results = []
    sum = 0
    length = chart_data.length
    avgWindow = undefined
    factor = 1  if not factor or factor <= 0

    # Create a sliding window of averages
    i = 0
    while i < length

      # Slice from i to factor
      avgWindow = chart_data.slice(i, i + factor)
      j = 0

      while j < avgWindow.length
        sum += avgWindow[j][0]
        j++
      x = sum / avgWindow.length

      sum = 0
      j = 0
      while j < avgWindow.length
        sum += avgWindow[j][1]
        j++
      y = sum / avgWindow.length

      results.push [x, y]
      sum = 0
      i += factor
    results


  timeToString: (t) ->
    ts = t.getFullYear()
    ts = ts + "-"
    ts = ts + ("0" + (t.getMonth() + 1)).slice(-2)
    ts = ts + "-"
    ts = ts + ("0" + t.getDate()).slice(-2)
    ts = ts + " "

    ts = ts + ("0" + t.getHours()).slice(-2)
    ts = ts + ":"
    ts = ts + ("0" + t.getMinutes()).slice(-2)
    ts = ts + ":"
    ts = ts + ("0" + t.getSeconds()).slice(-2)
    return ts

  getMeasDataAndDrawChart: () ->
    name = $("input[name='meas_name']").val()
    page = parseInt($("input[name=page]").val())
    limit = parseInt($("input[name=limit]").val())
    smooth = parseInt($("input[name=smooth]").val())

    flot_options =
      series:
        lines:
          show: true
          fill: true
        points:
          show: false
      legend:
        show: true
      grid:
        clickable: false
        hoverable: true


    @showWaitingSymbol()
    $.getJSON "/measurements/" + name + "?page=" + page + "&limit=" + limit, (data) =>
      buffer = data["buffer"]
      coefficient_linear = data["meas_cache"]["coefficient_linear"]
      coefficient_offset = data["meas_cache"]["coefficient_offset"]
      interval = data["meas_cache"]["interval"]
      last_time = data["meas_cache"]["last_time"]
      current_time = ( (new Date).getTime() / 1000.0 )
      time_offset = last_time - current_time - page * interval * buffer.length
      time_offset_last = current_time - last_time
      chart_length = $("#chart").width()
      max_page = data["range"]["max_page"]
      unit = data["meas_cache"]["unit"]

      # time ranges
      $("#time-from").html(data["range"]["time_from"])
      $("#time-to").html(data["range"]["time_to"])
      $("input[name=max_page]").html(max_page)

      new_data = []
      i = 0

      for d in buffer
        x = -1 * i * interval + time_offset
        y = ( parseFloat(d) + coefficient_offset ) * coefficient_linear

        new_d = [x, y]
        new_data.push new_d
        i += 1

      if new_data.length > chart_length
        factor = Math.ceil(parseFloat(new_data.length) / parseFloat(chart_length))
        smooth_data = averageData(new_data, factor + smooth)
        new_data = smooth_data

      $("#chart-info").html("<strong>" + buffer.length + "</strong> measurements")
      if buffer.length > 0
        time_range = new_data[0][0] - new_data[new_data.length - 1][0]
        $("#chart-info").html($("#chart-info").html() + ", " + "<strong>" + time_range + "</strong> seconds")
        $("#chart-info").html($("#chart-info").html() + ", " + "<strong>" + Math.round(time_offset_last) + "</strong> seconds ago")

      latest_unix_rel_time = new_data[0][0]
      oldest_unix_rel_time = new_data[new_data.length - 1][0]
      center_unix_rel_time = (latest_unix_rel_time + oldest_unix_rel_time) / 2.0
      offset_unix_rel_time = latest_unix_rel_time - center_unix_rel_time

      new_data =
        data: new_data
        color: "#55f"
        label: name

      $.plot "#chart", [new_data], flot_options

      $("#chart").bind "plothover", (event, pos, item) =>
        if item
          #legend = $("#chart .legendLabel")
          #legend.html(item)
          t = new Date()
          t = new Date(t.getTime() + parseFloat(item.datapoint[0]) * 1000.0)
          v = item.datapoint[1]

          $("#current-point").html(@timeToString(t) + " " + v.toFixed(2) + " " + unit)
        return

      $("#chart").bind "plotclick", (event, pos, item) =>
        # TODO not compatible at this moment
        x = pos.x
        x_offset = center_unix_rel_time - x
        x_offset_page = x_offset / offset_unix_rel_time
        page = parseFloat($("input[name=page]").val()) + x_offset_page
        $("input[name=page]").val(page)
        @getMeasDataAndDrawChart()
        return

      @afterGetMeasDataAndDrawChart(name)
      @createMeasPaginationAndZoomButton(name, page, limit, max_page)
      @hideWaitingSymbol()

  onActionButtonClick: (event) ->
    tag = $(event.currentTarget)
    name = tag.attr("data-action-name")
    url = "/actions/" + name + "/execute"

    @showWaitingSymbol()

    $.ajax
      type: "POST"
      url: url
      dataType: "json"
      success: (data) =>
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
        @hideWaitingSymbol()



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

    return false

  onToggleAutoRefresh: (event) ->
    tag = $(event.currentTarget)
    is_refresh = parseInt($("input[name='auto_refresh']").val())

    if is_refresh == 1
      $("input[name='auto_refresh']").val(0)
      tag.html("No auto refresh")
    else
      $("input[name='auto_refresh']").val(1)
      tag.html("Auto refresh")

    return false
