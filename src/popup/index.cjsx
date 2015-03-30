
React = require 'react'
ApplicationView = require './components/application'
Application = require './application'

tab = require './utils/tab'

# For debugging
window.React = React

view = React.render <ApplicationView />, document.body

app = window.app = new Application view
tab.getOriginOfCurrentTab (x) -> app.load x
