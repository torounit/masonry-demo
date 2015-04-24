
# ==================================
#
# Load modules.
#
# ==================================
source        = require 'vinyl-source-stream'
buffer        = require 'vinyl-buffer'
browserify    = require 'browserify'
browserSync   = require 'browser-sync'

gulp          = require 'gulp'
$ = require('gulp-load-plugins')()

AUTOPREFIXER_BROWSERS = [
  'ie >= 10',
  'ie_mob >= 10',
  'ff >= 30',
  'chrome >= 34',
  'safari >= 7',
  'opera >= 23',
  'ios >= 7',
  'android >= 4.4',
  'bb >= 10'
];


# ==================================
#
# Directory Setting.
#
# ==================================
dir =
  assets: './assets'
  src: './assets/src'
  dist: './assets/dist'
  vendor: './vendor/assets/bower_components/'


# ==================================
#
# Sass
#
# ==================================

gulp.task 'sass', () ->
#  gulp.src dir.src + '/styles/**/*.scss'
#  .pipe $.sourcemaps.init()
#  .pipe $.sass()
  $.rubySass dir.src + '/styles/', {sourcemap: true, style: 'compact'}
  .pipe $.autoprefixer()
  .pipe $.sourcemaps.write {
    includeContent: false,
    sourceRoot: '/wp-content/themes/mcmoa/assets/src/styles'
  }
  .pipe gulp.dest dir.dist + '/styles'
  .pipe $.livereload()


gulp.task 'sass:dist', () ->
  $.rubySass dir.src + '/styles/', { style: 'compact' }
  .pipe $.pleeease
    minifier: true
  .pipe $.rename extname: ".min.css"
  .pipe gulp.dest dir.dist + '/styles'


# ==================================
#
# minify images
#
# ==================================

gulp.task 'image', ->
  gulp.src(dir.src + '/images/**/*')
  .pipe $.plumber errorHandler: $.notify.onError('<%= error.message %>')
  .pipe $.imagemin
      progressive: true,
      svgoPlugins: [{removeViewBox: false}],
  .pipe gulp.dest dir.dist + '/images'
  .pipe $.livereload()


# ==================================
#
# Compile JavaScripts.
#
# ==================================

jsbuild = ->
  b = browserify
    extensions: ['.coffee']
    debug: true

  b.transform 'coffeeify'
  b.transform "browserify-shim"
  b.transform "debowerify"
  b.add dir.src + '/scripts/all.coffee'
  b.bundle()

gulp.task 'scripts', ->
  b = browserify
    extensions: ['.coffee']
    debug: true

  b.transform 'coffeeify'
  b.transform "browserify-shim"
  b.transform "debowerify"
  b.add dir.src + '/scripts/all.js'
  b.bundle()
  .pipe $.plumber errorHandler: $.notify.onError('<%= error.message %>')
  .pipe source 'all.js'
  .pipe gulp.dest dir.dist + '/scripts/'
  .pipe $.livereload()

gulp.task 'scripts:dist', ->
  b = browserify
    extensions: ['.coffee']
    debug: false

  b.transform 'coffeeify'
  b.transform "browserify-shim"
  b.transform "debowerify"
  b.add dir.src + '/scripts/all.coffee'
  b.bundle()
  .pipe $.plumber errorHandler: $.notify.onError('<%= error.message %>')
  .pipe source 'all.min.js'
  .pipe buffer()
  .pipe $.uglify()
  .pipe gulp.dest dir.dist + '/scripts/'

# ==================================
#
# browser-sync
#
# ==================================

gulp.task 'browser-sync', ->
  browserSync proxy: 'mcmoa.local'

gulp.task 'bs-reload', ->
  browserSync.reload()

# ==================================
#
# watch.
#
# ==================================

gulp.task 'watch', ->
  $.livereload.listen()
  $.watch dir.src + '/styles/**/*', ->
    gulp.start 'sass'

  $.watch dir.src + '/scripts/**/*',->
    gulp.start 'scripts'

  $.watch dir.src + '/images/**/*',->
    gulp.start 'image'

  $.watch "./**/*.php", ->
    $.livereload()


# ==================================
#
# tasks.
#
# ==================================

gulp.task 'build:dist', [ 'sass:dist', 'scripts:dist' , 'image' ]
gulp.task 'build', [ 'sass', 'scripts' , 'image' ]
gulp.task 'default', ['build', 'watch' ]
