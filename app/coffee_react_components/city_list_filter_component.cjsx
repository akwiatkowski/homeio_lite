# @cjsx React.DOM
@CityListFilter = React.createClass
  doSearch: ->
    query = this.refs.searchInput.getDOMNode().value
    this.props.doSearch(query);

  render: ->
    <input placeholder="City search" value={this.props.filterQuery} ref="searchInput" onChange={this.doSearch}/>
