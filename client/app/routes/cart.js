import Ember from 'ember';
import ResetScrollMixin from 'client/mixins/reset-scroll';

const {
  RSVP: {all, hash}
} = Ember;

export default Ember.Route.extend(ResetScrollMixin, {
  model () {
    return this.store.findAll('booking');
  },

  afterModel (bookings) {
    //preloads!
    return hash({
      products: all(bookings.mapBy('product')),
      categories: all(bookings.mapBy('category')),
      activities: all(bookings.mapBy('activity')),
      experiences: all(bookings.mapBy('experience'))
    });
  },

  setupController (controller, bookings) {
    this._super(...arguments);
    controller.set('bookings', bookings);
  },

  actions: {
    updateBooking (booking, price, _amount, quantity) {
      let priceId = price.id;
      let shouldSave = true;
      let updatedQuantities = booking.get('quantities').map(q => {
        if (q.id === priceId && q.quantity === quantity)  {
          // not an actual save, get outta here!
          // this happens due to our bindings in components
          // registering as changes and turning into actions...
          // bummer.
          // should fix that someday.
          return shouldSave = false;
        } else if (q.id === priceId) {
          return {
            id: priceId,
            quantity: quantity
          };
        }
        return q;
      });

      if (shouldSave) {
        booking.set('quantities', updatedQuantities);
        return booking.save();
      }
    },
    removeBooking (booking) {
      return booking.destroyRecord();
    }
  }
});
