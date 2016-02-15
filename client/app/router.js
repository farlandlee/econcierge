import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('experiences', {path: ':activity_slug/:category_slug/:date'}, function () {
    this.route('default-experience', {path: '/'});
    this.route('experience', {path: ':experience_slug'}, function () {
      this.route('products', {path: '/'});
    });
  });
});

export default Router;
