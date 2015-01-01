# @cjsx React.DOM
@Weather = React.createClass
  render: ->
    <Weather temperature={1.1}} data-colour="red" on>
      <p className="temperature">{@props?.temperature}</p>
    </Weather>