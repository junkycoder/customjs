
Kefir = require 'kefir'
{List, fromJS} = require 'immutable'
{comp, filter, map} = require 'transducers-js'

storage = require './utils/storage'

register = (stream, messageType, handler) ->
  xform = comp(
    filter (x) => x.first() is messageType
    map (x) => x.rest()
  )
  stream.transduce(xform).onValue handler

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
    @state = fromJS data.script

    @emit 'state-changed', 'receive', @state

  update: (script) ->
    @state = script
    console.warn 'TODO', 'save script as draft'
    @emit 'state-changed', 'update', @state

  save: ->
    console.warn 'TODO', 'save script'

  remove: ->
    console.warn 'TODO', 'save remove'

  render: ->
    @view.setProps
      websites: @websites
      script: @state
      messages:
        emit: @emit.bind this
        on: @on.bind this

module.exports = Application
