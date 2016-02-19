import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function () {
  this.route('checkout');

  this.route('explore', {path: ':activity_slug/:category_slug/:date'}, function () {
    this.route('default-experience', {path: '/'});
    this.route('experience', {path: ':experience_slug'}, function () {
      this.route('products', {path: '/'}, function () {
        this.route('book', {path: '/book/:product_id'});
      });
    });
  });

  this.route('error404', {path: '/*path'});
});

export default Router;
