React = require 'react'

module.exports = React.createClass
  render: ->
    websites = @props.data
    options  = websites.all.map (web) ->
      <option key={web}>{web}</option>

    <div>
      <select value={websites.selected} onChange={@_onChange}>
        {options}
      </select>
    </div>

  _onChange: (e) ->
    website = e.target.value
    @props.onChange website

