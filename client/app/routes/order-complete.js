import Ember from 'ember';
import ResetScrollMixin from 'client/mixins/reset-scroll';

export default Ember.Route.extend(ResetScrollMixin, {
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
