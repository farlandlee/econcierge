import Ember from 'ember';

const {computed} = Ember;

export default Ember.Component.extend({
  bookings: null,
  itemCount: computed('bookings.[]', {
    get () {
      return this.get('bookings.length') + 1;
    }
  }),
  total: computed('bookings.[]', {
    get () {
      return this.get('bookings').reduce((total, booking) => {
        return total + booking.get('total');
      }, 0);
    }
  })
});
