
config       = require('../config').browserify

browserify   = require 'browserify'
watchify     = require 'watchify'
bundleLogger = require '../util/bundleLogger'
gulp         = require 'gulp'
handleErrors = require '../util/handleErrors'
source       = require 'vinyl-source-stream'

gulp.task 'browserify', (callback) ->

  bundleQueue = config.bundleConfigs.length

  browserifyThis = (bundleConfig) ->

    bundler = browserify(
      # Required watchify args
      cache: {}, packageCache: {}, fullPaths: true
      # Specify the entry point of your app
      entries: bundleConfig.entries
      # Add file extentions to make optional in your requires
      extensions: config.extensions
      # Enable source maps!
      debug: config.debug
    )

    bundle = ->
      # Log when bundling starts
      bundleLogger.start(bundleConfig.outputName)

      return bundler
        .bundle()
        # Report compile errors
        .on 'error', handleErrors
        # Use vinyl-source-stream to make the
        # stream gulp compatible. Specifiy the
        # desired output filename here.
        .pipe source bundleConfig.outputName
        # Specify the output destination
        .pipe gulp.dest bundleConfig.dest
        .on 'end', reportFinished

    if global.isWatching
      # Wrap with watchify and rebundle on changes
      bundler = watchify bundler
      # Rebundle on update
      bundler.on 'update', bundle

    reportFinished = ->
      # Log when bundling completes
      bundleLogger.end(bundleConfig.outputName)

      if bundleQueue
        bundleQueue--
        if bundleQueue is 0
          # If queue is empty, tell gulp the task is complete.
          # https://github.com/gulpjs/gulp/blob/master/docs/API.md#accept-a-callback
          do callback

     do bundle

  # Start bundling with Browserify for each bundleConfig specified
  config.bundleConfigs.forEach browserifyThis

