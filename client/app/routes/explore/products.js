import Ember from 'ember';
import {parseDate} from 'client/utils/time';

const {
  RSVP: {all, hash}
} = Ember;

export default Ember.Route.extend({
  model ({date}) {
    if (date && !parseDate(date).isValid()) {
      this.transitionTo({queryParams: {date: undefined}});
    }

    let category_id = this.modelFor('explore').category.get('id');

    let productsQuery = this.store.query('product', {
      date, category_id
    });

    return hash({
      products: productsQuery,
      date: date
    });
  },

  afterModel ({products}) {
    return all(products.mapBy('vendor'));
  },

  setupController (controller, model) {
    this._super(...arguments);
    controller.setProperties(model);
    let activityAmenities = this.modelFor('explore').activity.get('amenities');
    controller.set('activityAmenities', activityAmenities);
    controller.set('activities', this.store.peekAll('activity'));
    let { activity, category } = this.modelFor('explore');
    controller.setProperties({activity, category});
  },

  renderTemplate (controller, model) {
    this._super(...arguments);
    this.render('explore/filters', {
      into: 'explore',
      outlet: 'explore-left',
      controller, model
    });
  }
});
