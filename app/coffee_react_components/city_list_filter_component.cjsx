# @cjsx React.DOM
@CityListFilter = React.createClass
  getInitialState: ->
    {
      filterQuery: this.props.filterQuery,
      siteLat: this.props.siteLat,
      siteLon: this.props.siteLon,
    }

  doQuerySearch: (event) ->
    query = this.refs.searchInput.getDOMNode().value
    this.setState {filterQuery: query}
    this.props.doQuerySearch(query)

  doUpdateSite: (event) ->
    lat = this.refs.latInput.getDOMNode().value
    lon = this.refs.lonInput.getDOMNode().value
    this.props.doUpdateSite(lat, lon)

  render: ->
    <div className="cityListFilters">
      <input placeholder="City search" value={this.state.filterQuery} ref="searchInput" onChange={this.doQuerySearch}/>
      <input placeholder="Site lat" value={this.state.siteLat} ref="latInput" onChange={this.doUpdateSite}/>
      <input placeholder="Site lon" value={this.state.siteLon} ref="lonInput" onChange={this.doUpdateSite}/>
    </div>
