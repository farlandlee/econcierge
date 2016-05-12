import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';

const {RSVP} = Ember;

export default Ember.Route.extend(NotFoundMixin, RouteTitleMixin, RouteDescriptionMixin, {
  titleToken (product) {
    return product.get('name');
  },

  description (product) {
    return product.get('description');
  },

  serialize (product) {
    return {
      activity_slug: product.get('activity.slug'),
      product_id: product.get('id')
    };
  },

  model ({product_id}) {
    return this.store.findRecord('product', product_id);
  },

  afterModel (product) {
    return RSVP.hash({
      activity: product.get('activity'),
      vendor: product.get('vendor')
    });
  },

  setupController (controller, product) {
    this._super(...arguments);
    controller.set('product', product);
  },

  actions: {
    book (product, {quantities, date, time}) {
      let activity = product.get('activity');
      let startTime = {
        time: time.starts_at_time,
        id: time.id
      };

      let booking = this.store.createRecord('booking', {
        activity,
        date,
        product,
        quantities,
        startTime
      });

      return booking.save().then(booking => {
        this.transitionTo('booked', booking.id);
      }, error => {
        //@TODO...
        console.error(error);
        throw error;
      });
    }
  }
});
