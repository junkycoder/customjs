immutable = require 'immutable'

module.exports =
  getInitialData: (origin, callback) ->
    # TODO: chrome.storage.get

    data =
      websites:
        all: [origin, 'hoho']
        selected: origin
        current: origin
      script:
        enable: false
        source: 'some source'

    callback data
