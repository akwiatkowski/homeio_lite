# @cjsx React.DOM
@CityList = React.createClass
  doSearch: (query) ->
    this.state.filterQuery = query
    @processCitiesList()
    console.log(query)

  getInitialState: ->
    {
      filterQuery: "",
      list: @props.list,
      filteredList: @props.list,
      cities: []
    }

  processCitiesList: ->
    filterResult = []
    for city in this.state.filteredList
      if city.name.toLowerCase().indexOf(this.state.filterQuery.toLowerCase()) != -1
        filterResult.push(<City name={city.name} lat={city.lat} lon={city.lon} />)

    this.setState {cities: filterResult}

  render: ->
    @props.listSize = @props.list.length
    <div className="cityList">
      <CityListFilter query={this.state.filterQuery} doSearch={this.doSearch}/>
      <div>List of cities {@props.listSize}</div>
      <div>{this.state.cities}</div>
    </div>
