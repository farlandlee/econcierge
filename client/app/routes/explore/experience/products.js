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
    let {date} = this.modelFor('explore');
    let experienceName = this.modelFor('explore.experience').get('name');
    let vendors = this.store.peekAll('vendor');

    controller.setProperties({
      products,
      vendors,
      date,
      experienceName
    });
  }
});
