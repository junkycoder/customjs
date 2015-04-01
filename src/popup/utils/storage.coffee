immutable = require 'immutable'

module.exports =
  getWebsiteData: (origin, callback) ->
    # TODO: chrome.storage.get

    data =
      websites: []
      scripts: []

    callback data

  setScripts: (origin, scripts, callback) ->

    console.log 'save', scripts
    do callback
