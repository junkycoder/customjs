
getCurrentTab = (callback) ->
  args = active: true, lastFocusedWindow: true
  chrome.tabs.query args, (tabs) -> callback tabs[0]

getOriginFromURL = (str) ->
  url = new URL str
  url.origin

module.exports =
  getOriginOfCurrentTab: (callback) ->
    getCurrentTab (tab) ->
      origin = getOriginFromURL tab.url
      callback origin
