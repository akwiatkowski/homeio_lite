# @cjsx React.DOM
@CityList = React.createClass
  doQuerySearch: (query) ->
    @state.filterQuery = query
    @processCitiesList()

  doUpdateSite: (newLat, newLon) ->
    @state.siteLat = newLat
    @state.siteLon = newLon
    @processCitiesList()

  calculateDistance: (sLat1, sLon1, sLat2, sLon2) ->
    lat1 = parseFloat(sLat1)
    lon1 = parseFloat(sLon1)
    lat2 = parseFloat(sLat2)
    lon2 = parseFloat(sLon2)

    R = 6371 # km
    fi1 = lat1 * (Math.PI/180)
    fi2 = lat2 * (Math.PI/180)
    deltaFi = (lat2-lat1)* (Math.PI/180)
    deltaGamma = (lon2-lon1)* (Math.PI/180)

    a = Math.sin(deltaFi/2) * Math.sin(deltaFi/2) + Math.cos(fi1) * Math.cos(fi2) * Math.sin(deltaGamma/2) * Math.sin(deltaGamma/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    d = R * c
    d

  getInitialState: ->
    {
      filterQuery: "",
      list: @props.list,
      filteredList: @props.list,
      cities: [],
      siteLat: 1.0
      siteLon: 1.0
    }

  processCitiesList: ->
    filterResult = []
    query = this.state.filterQuery.toLowerCase()

    for city in this.state.filteredList
      if city.name.toLowerCase().indexOf(query) != -1
        distance = @calculateDistance(city.lat, city.lon, @state.siteLat, @state.siteLon)
        newCity = <City key={city.id} name={city.name} lat={city.lat} lon={city.lon} siteLat={@state.siteLat} siteLon={@state.siteLon} distance={distance} />
        filterResult.push(newCity)

    this.setState {cities: filterResult}

  render: ->
    @props.listSize = @props.list.length
    <div className="cityList">
      <CityListFilter doQuerySearch={this.doQuerySearch} doUpdateSite={this.doUpdateSite}/>
      <div>List of cities {@props.listSize}</div>
      <div>{this.state.cities}</div>
    </div>
