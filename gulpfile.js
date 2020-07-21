const gulp = require('gulp');
const watch = require('gulp-watch');
const exec = require('child_process').exec;

gulp.task('default', function () {
  return watch('./reappay_superadmin', function (f) {
    if (f.history[0].includes('storage')) return;
    if (f.history[0].includes('.git')) return;
    if (f.history[0].includes('node_module')) return;
    if (f.history[0].includes('vendor')) return;

    const src = f.history[0];
    const dest = src
      .replace(
        'C:\\workspace\\2source\\reappay_superadmin_dev_server\\reappay_superadmin\\',
        ''
      )
      .split('\\')
      .join('/');

    if (f.event === 'unlink') {
      exec('docker exec reappay_superadmin_dev_server_src_1 rm /var/www/html/' + dest, function (err, stdout, stderr) {
        if (err) {
          console.log(err);
        } else if (stdout && stderr) {
          console.log(stdout);
          console.log(stderr);
        } else {
          console.log('delete: ' + dest);
        }
      })
    } else {
      exec(
        'docker cp ' + src + ' reappay_superadmin_dev_server_src_1:/var/www/html/' + dest,
        function (err, stdout, stderr) {
          if (err) {
            console.log(err);
          } else if (stdout && stderr) {
            console.log(stdout);
            console.log(stderr);
          } else {
            console.log('update: ' + dest);
          }
        }
      );
    }

  });
});
