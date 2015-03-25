###
  bundleLogger
  ------------
  Provides gulp style logs to the bundle method in browserify.js
###

gutil = require 'gulp-util'
prettyHrtime = require 'pretty-hrtime'
startTime = 0

module.exports =
  start: (filepath) ->
    startTime = process.hrtime()
    gutil.log 'Bundling', gutil.colors.green(filepath) + '...'

  end: (filepath) ->
    taskTime = process.hrtime startTime
    prettyTime = prettyHrtime taskTime
    gutil.log 'Bundled', gutil.colors.green(filepath),
      'in', gutil.colors.magenta(prettyTime)
