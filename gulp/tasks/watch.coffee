
config = require '../config'
gulp   = require 'gulp'

gulp.task 'watch', ['setWatch'], ->
  gulp.watch config.sass.src, ['sass']
  for cfg in config.static
    gulp.watch cfg.src, ['static']

