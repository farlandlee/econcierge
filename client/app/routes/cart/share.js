import Ember from 'ember';

const {
  inject: {service}
} = Ember;

export default Ember.Route.extend({
  ajax: service(),

  model () {
    let cart = this.modelFor('cart');
    if (cart.length <= 0) {
      return this.transitionTo('cart');
    }

    let payload = JSON.stringify({
      // map cart to a normal array that we can stringify
      bookings: cart.map(b => b)
    });

    return this.get('ajax').post('shared_cart', {data: payload});
  },

  setupController (controller, {url}) {
    this._super(...arguments);
    controller.set('shareUrl', url);
  },

  resetController (controller) {
    controller.set('success', false);
  },

  actions: {
    copied () {
      this.controller.set('success', true);
    },

    back () {
      this.transitionTo('cart');
    }
  }
});
