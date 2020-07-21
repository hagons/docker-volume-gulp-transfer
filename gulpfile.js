const gulp = require('gulp');
const watch = require('gulp-watch');
const exec = require('child_process').exec;

const project_name = 'reappay_superadmin';
const docker_name = `${project_name}_dev_server_src_1`;
const docker_path = '/var/www/html/';

gulp.task('default', () =>
  watch(`./${project_name}`, (f) => {
    const src = f.history[0];

    if (src.includes('storage')) return;
    if (src.includes('.git')) return;
    if (src.includes('node_module')) return;
    if (src.includes('vendor')) return;

    const dest = src.replace(f.base, '').split('\\').join('/');

    if (f.event === 'unlink') {
      exec(
        `docker exec ${docker_name} rm ${docker_path}${dest}`,
        (err, stdout, stderr) => {
          if (err) {
            console.log(err);
          } else if (stdout && stderr) {
            console.log(stdout);
            console.log(stderr);
          } else {
            console.log('delete: ' + dest);
          }
        }
      );
    } else {
      exec(
        `docker cp ${src} ${docker_name}:${docker_path}${dest}`,
        (err, stdout, stderr) => {
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
  })
);
