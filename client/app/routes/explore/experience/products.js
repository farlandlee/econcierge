import Ember from 'ember';
import {parseDate} from 'client/utils/time';

const {
  RSVP: {all, hash}
} = Ember;

export default Ember.Route.extend({
  queryParams: {
    date: {
      refreshModel: true
    }
  },

  model ({date}) {
    if (date && !parseDate(date).isValid()) {
      this.transitionTo({queryParams: {date: undefined}});
    }

    let experience = this.modelFor('explore.experience');

    let productsQuery = this.store.query('product', {
      experience_id: experience.id,
      date: date
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
    let {activity} = this.modelFor('explore');
    let amenities = activity.get('amenities');
    let experienceName = this.modelFor('explore.experience').get('name');
    controller.setProperties(model);
    controller.setProperties({
      experienceName,
      activityAmenities: amenities
    });
  }
});
