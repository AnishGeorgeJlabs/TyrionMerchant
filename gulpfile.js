var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var coffee = require('gulp-coffee');
var jade = require('gulp-jade');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');

var paths = {
  sass: ['./src/scss/**/*.scss'],
  main_sass: ['./src/scss/ionic.app.scss', './src/scss/app_bootstrap.scss'],
  coffee: ['./src/coffee/app.coffee', './src/coffee/controllers/*.coffee', './src/coffee/**/*.coffee'],
  jade: ['./src/jade/**/*.jade']
};

gulp.task('default', ['sass', 'coffee', 'jade']);

gulp.task('sass', function(done) {
  gulp.src(paths.main_sass)
    .pipe(sass())
    .on('error', sass.logError)
    .pipe(gulp.dest('./www/css/'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/css/'))
    .on('end', done);
});

gulp.task('coffee', function(done) {
  gulp.src(paths.coffee)
    .pipe(coffee().on('error', gutil.log))
    .pipe(concat('application.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./www/js/'))
    .on('end', done);
});

gulp.task('jade', function(done) {
  gulp.src(paths.jade)
    .pipe(jade({"pretty": true}))
    .pipe(gulp.dest('./www/'))
    .on('end', done);
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);
  gulp.watch(paths.jade, ['jade']);
});

gulp.task('install', ['git-check'], function() {
  return bower.commands.install()
    .on('log', function(data) {
      gutil.log('bower', gutil.colors.cyan(data.id), data.message);
    });
});

gulp.task('git-check', function(done) {
  if (!sh.which('git')) {
    console.log(
      '  ' + gutil.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
    );
    process.exit(1);
  }
  done();
});
