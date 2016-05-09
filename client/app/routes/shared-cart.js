import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';

const {
  inject: {service},
  RSVP: {all, hash}
} = Ember;

export default Ember.Route.extend(NotFoundMixin, {
  ajax: service(),

  beforeModel () {
    return this.store.findAll('booking').then(bookings => {
      return all(bookings.map(b => b.destroyRecord()));
    });
  },

  model ({uuid}) {
    return this.get('ajax').request(`shared_cart/${uuid}`)
    .then(({shared_cart: {bookings}}) => {
      let loadAssocs = Ember.run.bind(this, this._loadBookingAssocs);
      return all(bookings.map(loadAssocs));
    }).then(bookings => {
      return all(bookings.map(b => this.store.createRecord('booking', b).save()));
    });
  },

  afterModel () {
    return this.replaceWith('cart');
  },

  _loadBookingAssocs (b) {
    return hash({
      activity: this.store.findRecord('activity', b.activity),
      product: this.store.findRecord('product', b.product),
      quantities: b.quantities,
      startTime: b.startTime,
      date: b.date
    });
  }
});
