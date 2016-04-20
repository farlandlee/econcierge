import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';
import {format} from 'client/utils/time';

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
      let {date} = this.modelFor('explore.experience.products');
      if (date) {
        // maybe it's a date error? try without date.
        // @TODO let the user know it wasn't a valid date.
        return this.replaceWith('explore.experience.products.book', {
          queryParams: {date: undefined}
        });
      }
      return this.throwNotFound();
    }

    return product;
  },

  setupController (controller, product) {
    this._super(...arguments);
    let {date} = this.modelFor('explore.experience.products');
    controller.setProperties({product, date});
    controller.set('showVendor', false);
    controller.set('description', Ember.String.htmlSafe(product.get('description')));
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
