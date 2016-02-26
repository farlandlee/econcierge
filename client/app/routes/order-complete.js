import Ember from 'ember';

export default Ember.Route.extend({
  model () {
    return this.modelFor('application');
  },

  setupController (controller, activities) {
    this._super(...arguments);
    controller.set('activities', activities);
  },

  renderTemplate () {
    this._super(...arguments);
    this.render('activities', {
      into: 'orderComplete',
      outlet: 'activities',
      controller: 'orderComplete'
    });
  }
});
