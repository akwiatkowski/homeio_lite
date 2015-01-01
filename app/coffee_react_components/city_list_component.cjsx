# @cjsx React.DOM
@CityList = React.createClass
  getInitialState: ->
    {list: []}
  render: ->
    cities = []
    for city in @props.list
      cities.push(<City name={city.name} lat={city.lat} lon={city.lon} />)

    @props.listSize = @props.list.length
    <div className="cityList">
      <div>List of cities {@props.listSize}</div>
      <div>{cities}</div>
    </div>
