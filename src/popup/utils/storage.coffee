Const = require '../constants'
without = require 'lodash/array/without'

local = chrome.storage.local

getKey = (record, origin, index) ->
  parts = [origin]

  switch record
    when 'scripts'
      parts.push Const.SCRIPT_KEY_PREFIX

  parts.push index
  parts.join '-'

getScriptKey = (origin, index) ->
  getKey 'scripts', origin, index

mapKeys = (count, handler) ->
  arr = []; index = 0
  while index < count
    arr.push handler index
    index++
  arr

getWebsites = (origin, callback) ->
  local.get [Const.WEBSITES_KEY, origin], (data) ->
    websites = data[Const.WEBSITES_KEY] || []
    current  = data[origin] || Const.WEBSITE_STRUCTURE

    callback websites, current

module.exports =
  getWebsiteData: (origin, callback) ->
    getWebsites origin, (websites, current) ->
      data = {websites}

      toLoad = []
      keysRefs = {}

      for record, count of current
        data[record] = []
        # FIXME assign inside map funcion
        keys = mapKeys count, (i) ->
          key = getKey record, origin, i
          keysRefs[key] = record
          key

        toLoad = toLoad.concat keys

      # No data stored for current website
      return callback data unless toLoad.length

      local.get toLoad, (records, i) ->
        for key, recordData of records
          record = keysRefs[key]
          data[record].push recordData

        callback data

  # FIXME: We need it more abstract ~ set(record, ..)
  setScripts: (origin, scripts, callback) ->
    getWebsites origin, (websites, current) ->

      if websites.indexOf(origin) is -1
        websites.push origin

      toStore = {}
      toStore[Const.WEBSITES_KEY] = websites

      current.scripts = scripts.length
      toStore[origin] = current

      scripts.forEach (script, index) ->
        key = getScriptKey origin, index
        toStore[key] = script

      local.set toStore, callback

  removeWebsiteData: (origin, callback) ->
    getWebsites origin, (websites, current) ->
      websites = without websites, origin

      toRemove = [origin]
      for record, count of current
        keys = mapKeys count, (i) -> getKey record, origin, i
        toRemove = toRemove.concat keys

      toUpdate = {}
      toUpdate[Const.WEBSITES_KEY] = websites
      local.set toUpdate

      local.remove toRemove, -> local.set toUpdate, callback
