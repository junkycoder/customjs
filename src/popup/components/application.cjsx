React = require 'react'
Cursor = require 'immutable/contrib/cursor'

WebsiteSection = require './websiteSection'
ScriptSection  = require './scriptSection'

ApplicationView = React.createClass
  appReady: ->
    @props.messages?

  render: ->
    return <div /> unless @appReady()

    <div>
      <WebsiteSection data={@props.websites} onChange={@_changeWebsite} />
      <ScriptSection data={@props.script} onChange={@_update} />
      <button onClick={@_action} rel='save'>save</button>
      <button onClick={@_action} rel='remove'>remove</button>
    </div>

  _changeWebsite: (website) ->
    @props.messages.emit 'change-website', website

  _update: (script) ->
    @props.messages.emit 'update-script', script

  _action: (e) ->
    type = e.target.getAttribute 'rel'
    @props.messages.emit "#{type}-script"


module.exports = ApplicationView
