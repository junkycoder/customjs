React = require 'react'
Editor = require './editor'

module.exports = React.createClass
  render: ->
    script = @props.data
    enable = script.get 'enable'
    source = script.get 'source'

    <div>
      <input type='checkbox' checked={enable} onChange={@_onEnableChange} />
      <Editor value={source} onChange={@_onSourceChange} />
    </div>

  _onEnableChange: (e) ->
    enable = e.target.checked
    script = @props.data.set 'enable', enable
    @props.onChange script

  _onSourceChange: (source) ->
    script = @props.data.set 'source', source
    @props.onChange script

