/*jshint node:true*/
module.exports = {
  name: 'index-delivery',
  postBuild: function (results) {
    if(this.app.env !== 'test') {
      var fs = this.project.require('fs-extra');
      this.ui.writeLine('Moving index.html to index.html.eex');
      fs.copySync(results.directory + '/index.html', '../web/templates/explore/index.html.eex', {clobber: true});
    }
  }
};
