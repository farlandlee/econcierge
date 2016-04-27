import Ember from 'ember';

const {
  RSVP: {all}
} = Ember;

export default Ember.Route.extend({
  model ({date}) {
    let experience = this.modelFor('explore.experience');

    return this.store.query('product', {
      experience_id: experience.id
    }).then(products => {
      return {products, date};
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
