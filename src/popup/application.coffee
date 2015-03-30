
Kefir = require 'kefir'
{List, fromJS} = require 'immutable'
{comp, filter, map} = require 'transducers-js'

register = (stream, messageType, handler) ->
  xform = comp(
    filter (x) => x.first() is messageType
    map (x) => x.rest()
  )
  stream.transduce(xform).onValue handler

class Application
  constructor: (initialData, @view) ->
    @websites = initialData.websites
    @state = fromJS initialData.script

    @stream = Kefir.emitter()

    # For debugging
    @stream.map((x) => x.toJS()).log 'stream'

    @on 'update-script',  (x) => @update x.first()
    @on 'change-website', (x) => @changeWebsite x.first()
    @on 'save-script',   @save.bind this
    @on 'remove-script', @remove.bind this
    @on 'state-changed', @render.bind this

  on: (eventName, handler) ->
    register @stream, eventName, handler

  emit: ->
    @stream.emit new List arguments
    return

  update: (script) ->
    @state = script
    console.warn 'TODO', 'save script as draft'
    @emit 'state-changed', 'update', @state

  save: ->
    console.warn 'TODO', 'save script'

  remove: ->
    console.warn 'TODO', 'save remove'

  changeWebsite: (website) ->
    @websites.selected = website
    console.warn 'TODO', 'load data for new website'
    @emit 'state-changed', 'changeWebsite', @state

  render: ->
    @view.setProps
      websites: @websites
      script: @state
      messages:
        emit: @emit.bind this
        on: @on.bind this

module.exports = Application
