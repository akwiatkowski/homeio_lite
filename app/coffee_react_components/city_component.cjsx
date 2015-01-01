# @cjsx React.DOM
@City = React.createClass
  getInitialState: ->
    {lat: 0.0, lon: 0.0};
  render: ->
    <div className="cityComponent pure-button" dataLat="{@props.lat}">
      <div className="cityName">{@props.name}</div>
      <div className="cityCoords">{@props.lat},{@props.lon}</div>
    </div>
