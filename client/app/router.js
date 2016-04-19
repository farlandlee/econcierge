import Ember from 'ember';
import config from 'client/config/environment';
import {RouterTitleMixin} from 'client/mixins/route-title';

const Router = Ember.Router.extend(RouterTitleMixin, {
  location: config.locationType
});

Router.map(function () {
  this.route('activities');
  this.route('categories', {path: ':activity_slug/categories'});

  this.route('booked', {path: '/booked/:booking_id'});

  this.route('cart', function() {
    this.route('share');
    this.route('checkout');
  });

  this.route('orderComplete');

  this.route('shared-cart', {path: 'shared_cart/:uuid'});

  this.route('explore', {path: ':activity_slug/:category_slug'}, function () {
    this.route('products', {path: '/'}, function () {
      this.route('book', {path: '/book/:product_id'});
    });
  });

  this.route('error404', {path: '/*path'});
});

export default Router;
