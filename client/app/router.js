import Ember from 'ember';
import config from 'client/config/environment';
import {RouterTitleMixin} from 'client/mixins/route-title';

const Router = Ember.Router.extend(RouterTitleMixin, {
  location: config.locationType
});

Router.map(function () {
  this.route('legacyCategoriesRedirect', {path: '/:activity_slug/categories'});
  this.route('legacyBookRedirect', {path: '/:activity_slug/:category_slug/book/:product_id'});
  this.route('legacyBookRedirect', {path: '/:activity_slug/:category_slug/:exp_slug/book/:product_id'});

  this.route('activities');

  this.route('activity', {path: '/:activity_slug'}, function () {
    this.route('index', {path: '/'}); // redirects to explore with no category
    this.route('explore', {path: '/:category_slug'});
    this.route('product', {path: '/experience/:product_id'});
  });

  this.route('booked', {path: '/booked/:booking_id'});

  this.route('cart', function() {
    this.route('share');
    this.route('checkout');
  });

  this.route('orderComplete');

  this.route('shared-cart', {path: 'shared_cart/:uuid'});

  this.route('error404', {path: '/*path'});
});

export default Router;
