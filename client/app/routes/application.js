import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    return this.store.findAll('activity');
  },
  setupController (controller, activities) {
    this._super(...arguments);
    controller.set('activities', activities);
  }
});
