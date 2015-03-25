
path = require 'path'
root = path.resolve './'

dest = "#{root}/dest"
src  = "#{root}/src"

nodeModules = root + '/node_modules'

module.exports =
  browserify:
    # Enable source maps
    debug: true
    # Additional file extentions to make optional
    extensions: ['.coffee', '.cjsx']
    # A separate bundle will be generated for each
    # bundle config in the list below
    bundleConfigs: [{
      entries: "#{src}/popup/index.cjsx"
      dest: dest
      outputName: "popup/index.js"
    }, {
      entries: "#{src}/background/index.coffee"
      dest: dest
      outputName: "background.js"
    }]

  sass:
    src: "#{src}/assets/sass/*{sass,scss}"
    dest:  "#{dest}/styles/"
    settings:
      # Required if you want to use SASS syntax
      # See https://github.com/dlmanning/gulp-sass/issues/81
      sourceComments: 'map'
      imagePath: 'images' # Used by the image-url helper

  static: [{
    src: "#{src}/popup/index.html"
    dest: "#{dest}/popup/"
  }, {
    src: "#{src}/manifest.json"
    dest: dest
  }, {
    src: "#{src}/assets/images/**"
    dest: "#{dest}/images/"
  }]

