var gulp = require("gulp");
var connect = require("gulp-connect");
var path = require("path");

var paths = [
  "./**/*.md",
  "./**/*.html",
  "./**/*.js"
];

gulp.task("connect", function() {
  connect.server({
    livereload: true,
    port: 8000,
    root: path.resolve("./")
  });
});

gulp.task("watch", function() {
  gulp.watch(paths, ["reload"]);
});

gulp.task("reload", function() {
  gulp.src(paths)
    .pipe(connect.reload());
});

gulp.task("default", ["connect", "watch"]);