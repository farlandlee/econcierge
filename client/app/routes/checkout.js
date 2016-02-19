import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    return this.store.findAll('booking');
  },

  setupController (controller, bookings) {
    this._super(...arguments);
    controller.set('bookings', bookings);
  }
});
