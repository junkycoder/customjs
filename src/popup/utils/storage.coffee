immutable = require 'immutable'

module.exports =
  getWebsiteData: (origin, callback) ->
    # TODO: chrome.storage.get

    data =
      websites: []
      scripts: []

    callback data

  setScripts: (origin, scripts, callback) ->

    do callback

  removeScripts: (origin, callback) ->

    do callback
