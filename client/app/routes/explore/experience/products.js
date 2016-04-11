import Ember from 'ember';

const {
  RSVP: {all}
} = Ember;

export default Ember.Route.extend({
  model () {
    let experience = this.modelFor('explore.experience');
    let {date} = this.modelFor('explore');

    let query = {
      experience_id: experience.id,
      date: date
    };

    return this.store.query('product', query);
  },

  afterModel (products) {
    return all(products.mapBy('vendor'));
  },

  setupController (controller, products) {
    this._super(...arguments);
    let {date, activity} = this.modelFor('explore');
    let amenities = activity.get('amenities');
    let experienceName = this.modelFor('explore.experience').get('name');

    controller.setProperties({
      products,
      date,
      experienceName,
      activityAmenities: amenities
    });
  }
});
