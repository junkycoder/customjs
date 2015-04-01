React = require 'react'
Cursor = require 'immutable/contrib/cursor'

constant = require '../constants'

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
      <a hidden={!@props.draftPresent} href='#' onClick={@_removeDraft}>
        remove draft
      </a>
    </div>

  _changeWebsite: (website) ->
    @props.messages.emit 'change-website', website

  _update: (script) ->
    @props.messages.emit 'update-script', script

  _action: (e) ->
    type = e.target.getAttribute 'rel'
    @props.messages.emit "#{type}-script"

  _removeDraft: (e) ->
    @props.messages.emit "remove-draft"



module.exports = ApplicationView
