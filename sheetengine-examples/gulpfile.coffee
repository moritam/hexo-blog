g = require('gulp')
$ = require('gulp-load-plugins')()
browserSync = require('browser-sync')

# BrowserSync
g.task 'bs', ->
  browserSync.init(null, {
    server:
      baseDir: './'
    # Stop the browser from automatically opening
    open: true
    # Open the site in Chrome & Firefox
    browser: ["google chrome canary"]
  })

# Tasks
g.task 'bsReload', ->
  browserSync.reload()

# Watch
g.task 'default', ['bs'], ->
  g.watch ['./**/*.html', './**/*.js'], ['bsReload']