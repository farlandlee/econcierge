import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('activity', {path: ':activity_slug'}, function () {
    this.route('category', {path: ':category_slug'}, function () {
      this.route('experience', {path: ':date'}, function() {
        this.route('product', {path: ':experience_slug'});
      });
    });
  });
});

export default Router;
