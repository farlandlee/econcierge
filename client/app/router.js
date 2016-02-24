import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function () {
  this.route('activities');
  this.route('categories', {path: ':activity_slug/categories'});

  this.route('explore', {path: ':activity_slug/:category_slug/:date'}, function () {
    this.route('default-experience', {path: '/'});
    this.route('experience', {path: ':experience_slug'}, function () {
      this.route('products', {path: '/'}, function () {
        this.route('book', {path: '/book/:product_id'});
      });
    });
  });

  this.route('booked', {path: '/booked/:booking_id'});
  this.route('cart', function() {
    this.route('checkout');
  });
  this.route('orderComplete');

  this.route('error404', {path: '/*path'});
});

export default Router;
