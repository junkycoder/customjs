
React = require 'react'
ApplicationView = require './components/application'
Application = require './application'

# For debugging
window.React = React

view = React.render <ApplicationView />, document.body

init = (initialData) ->
  try
    app = window.app = new Application initialData, view
    app.render()
  catch e
    console.error e

tabUtils     = require './utils/tab'
storageUtils = require './utils/storage'

tabUtils.getOriginOfCurrentTab (origin) ->
  storageUtils.getInitialData origin, init
