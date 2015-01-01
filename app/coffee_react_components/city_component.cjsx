# @cjsx React.DOM
@City = React.createClass
  calculatedDistance: ->
    console.log("calc")
    console.log(this)
    @props.siteLat + @props.siteLon

  getInitialState: ->
    {lat: 0.0, lon: 0.0, distance: 10.0};

  render: ->
    <div className="cityComponent pure-button" dataLat="{@props.lat}">
      <div className="cityName">{@props.name}</div>
      <div className="cityCoords">{@props.lat},{@props.lon}</div>
      <div className="cityDistance">{@props.distance}</div>
      <div className="site">{@props.siteLat},{@props.siteLon}</div>
    </div>
