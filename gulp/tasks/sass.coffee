
config       = require('../config').sass

gulp         = require 'gulp'
sass         = require 'gulp-sass'
sourcemaps   = require 'gulp-sourcemaps'
handleError  = require '../util/handleErrors'

gulp.task 'sass', ->
  gulp.src config.src
    .pipe sourcemaps.init()
    .pipe sass(config.settings)
    .on 'error', handleError
    .pipe sourcemaps.write()
    .pipe gulp.dest(config.dest)
