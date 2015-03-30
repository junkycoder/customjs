React = require 'react'

ace = require 'brace'
require 'brace/mode/javascript'
require 'brace/theme/tomorrow'

changeDelay = 300
changeTimer = null

module.exports = React.createClass
  getDefaultProps: ->
    mode:  'javascript'
    theme: 'tomorrow'
    onChange: ->

  getInitialState: ->
    value: @props.value || ''

  componentDidMount: ->
    @editor = ace.edit @getDOMNode()
    @editSession = @editor.getSession()

    @editSession.setMode "ace/mode/#{@props.mode}"
    @editor.setTheme "ace/theme/#{@props.theme}"
    @editor.setValue @props.value, 1

    do @editor.focus

    @editor.on 'change', =>
      value = @editor.getValue()
      @_onChange value

    @editor.on 'blur', =>
      value = @editor.getValue()
      @_onBlur value

  componentWillUnmount: ->
    @editor.destroy()

  componentWillReceiveProps: (newProps) ->
    value = newProps.value

    if @_updateValueState value
      @editor.setValue value, 1
      clearTimeout changeTimer

  render: ->
    style = height: '300px'
    <div className='editor' style={style}></div>

  _updateValueState: (value) ->
    if @state.value is value
      return false
    else
      @setState value: value
      return true

  _onChange: (value) ->
    if @_updateValueState value
      clearTimeout changeTimer
      changeTimer = setTimeout (=>
        @props.onChange value
      ), changeDelay

  _onBlur: (value) ->
    if @_updateValueState value
      @props.onChange value



