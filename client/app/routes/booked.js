import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, {
  model (params) {
    let {booking_id} = params;
    return Ember.RSVP.hash({
      bookings: this.store.findAll('booking'),
      activities: this.store.peekAll('activity')
    }).then(({bookings, activities}) => {
      let booking = bookings.findBy('id', booking_id);
      if (!booking) {
        return this.throwNotFound();
      }
      return {
        bookings,
        booking,
        activities
      };
    });
  },

  afterModel (model) {
    return Ember.RSVP.all(model.bookings.mapBy('product'));
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
  },

  renderTemplate () {
    this._super(...arguments);
    this.render('activities', {
      into: 'booked',
      outlet: 'activities',
      controller: 'booked'
    });
  }
});
