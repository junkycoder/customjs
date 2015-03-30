immutable = require 'immutable'

module.exports =
  getWebsiteData: (origin, callback) ->
    # TODO: chrome.storage.get

    data =
      websites: [origin, 'hoho']
      script:
        enable: false
        source: 'some source'

    callback data
