import Ember from 'ember';

export default Ember.Route.extend({
  actions: {
    back () {
      this.transitionTo('cart');
    },
    checkout (user, stripeToken) {
      // map bookings so that we have a basic array,
      // rather than a record array (can't stringify record arrays)
      let bookings = this.modelFor('cart').map(b => b);
      let payload = JSON.stringify({
        cart: bookings,
        user: user,
        stripe_token: stripeToken
      });
      Ember.$.ajax('/web_api/checkout', {
        method: 'POST',
        data: payload,
        contentType: 'application/json',
      }).then(() => {
        this.transitionTo('orderComplete');
      }, () => {
        this.transitionTo('error');
      });
    }
  }
});
