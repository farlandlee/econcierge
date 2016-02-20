import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    return this.store.peekAll('activity');
  },
  setupController (controller, activities) {
    this._super(...arguments);
    controller.set('activities', activities);
  }
});
