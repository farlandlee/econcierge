import Ember from 'ember';
import RouteTitleMixin from 'client/mixins/route-title';

export default Ember.Route.extend(RouteTitleMixin, {
  titleToken: 'Checkout',

  beforeModel () {
    let hasBookings = this.modelFor('cart').get('length');
    if (!hasBookings) {
      this.transitionTo('cart');
    }
  },

  model () {
    return this.modelFor('cart');
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.set('cart', model);
  },

  actions: {
    back () {
      this.transitionTo('cart');
    },
    showOrderComplete (cart) {
      cart.forEach(i => i.destroyRecord());
      this.transitionTo('orderComplete');
    }
  }
});
