import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';

export default Ember.Route.extend(NotFoundMixin, RouteTitleMixin, RouteDescriptionMixin, {
  titleToken (product) {
    return product.get('name');
  },

  description (product) {
    return product.get('description');
  },

  model (params) {
    let {product_id} = params;
    let product = this.store.peekRecord('product', product_id);

    if (!product) {
      return this.throwNotFound();
    }

    return product;
  },

  setupController (controller, product) {
    this._super(...arguments);
    controller.set('product', product);
    controller.set('showVendor', false);
  },

  actions: {
    goToProducts () {
      this.transitionTo('explore.experience.products');
    },

    book (product, {quantities, date, time}) {
      let {category, activity} = this.modelFor('explore');
      let experience = this.modelFor('explore.experience');
      time = {
        time: time.starts_at_time,
        id: time.id
      };

      let booking = this.store.createRecord('booking', {
        activity: activity,
        experience: experience,
        category: category,
        product: product,
        date: date,
        startTime: time,
        quantities: quantities
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
