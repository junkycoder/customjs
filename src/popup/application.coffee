
Kefir = require 'kefir'
{List, fromJS} = require 'immutable'
{comp, filter, map} = require 'transducers-js'

window.List = List

storage = require './utils/storage'

register = (stream, messageType, handler) ->
  xform = comp(
    filter (x) => x.first() is messageType
    map (x) => x.rest()
  )
  stream.transduce(xform).onValue handler

INITIAL_STATE = 0
DRAFT_STATE   = 1

INITIAL_SCRIPT =
  enable: false
  source: '// Here you can type your script'
  state: INITIAL_STATE

class Application
  websites:
    all: []
    current: null
    selected: null

  constructor: (@view) ->
    @stream = Kefir.emitter()

    # For debugging
    @stream.map((x) => x.toJS()).log 'stream'

    @on 'update-script',  (x) => @update x.first()
    @on 'change-website', (x) => @load x.first()
    @on 'save-script',   @save.bind this
    @on 'remove-script', @remove.bind this
    @on 'state-changed', @render.bind this

  on: (eventName, handler) ->
    register @stream, eventName, handler

  emit: ->
    @stream.emit new List arguments
    return

  load: (website) ->
    @websites.selected = website
    @websites.current ?= website

    storage.getWebsiteData website, @receive.bind this

  receive: (data) ->
    @websites.all = data.websites

    if @websites.all.indexOf @websites.current
      @websites.all.push @websites.current

    # Array of max 2 items (script and draft)
    @scripts = fromJS data.scripts

    if @scripts.count() is 0
      @scripts = @scripts.push fromJS INITIAL_SCRIPT

    @emit 'state-changed', 'receive', data

  update: (script) ->
    state = script.get 'state'

    switch state
      when INITIAL_STATE
        script   = script.set 'state', DRAFT_STATE
        @scripts = @scripts.set -1, script

      when DRAFT_STATE
        @scripts = @scripts.set -1, script

      else
        script   = script.set 'state', DRAFT_STATE
        @scripts = @scripts.push script

    storage.setScripts @websites.selected, @scripts.toJS(), =>
      @emit 'state-changed', 'update', script

  save: ->
    console.warn 'TODO', 'save script'

  remove: ->
    console.warn 'TODO', 'save remove'

  render: ->
    @view.setProps
      websites: @websites
      script: @scripts.last()
      messages:
        emit: @emit.bind this
        on: @on.bind this

module.exports = Application
