import Ember from 'ember';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';

const {
  RSVP: {all, hash}
} = Ember;

export default Ember.Route.extend(ResetScrollMixin, RouteTitleMixin, RouteDescriptionMixin, {
  titleToken: 'Activities Cart',
  description: 'Online Shopping cart for Jackson Hole Activities',

  model () {
    return this.store.findAll('booking');
  },

  afterModel (bookings) {
    //preloads!
    return hash({
      products: all(bookings.mapBy('product')),
      activities: all(bookings.mapBy('activity'))
    });
  },

  setupController (controller, bookings) {
    this._super(...arguments);
    controller.set('bookings', bookings);
    controller.set('sort', ['date:asc']);
  },

  actions: {
    updateBooking (booking, price, amount, quantity) {
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
            quantity: quantity,
            cost: amount.amount * quantity
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
