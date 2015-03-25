
config = require('../config').static
gulp   = require 'gulp'

gulp.task 'static', ->
  for cfg in config
    gulp.src(cfg.src).pipe gulp.dest(cfg.dest)

