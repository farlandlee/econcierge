import Ember from 'ember';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';

export default Ember.Route.extend(ResetScrollMixin, RouteTitleMixin, RouteDescriptionMixin, {
  titleToken: 'Activities',

  description: 'Online booking for all the great Jackson Hole activities',

  model () {
    return this.store.peekAll('activity');
  },

  setupController (controller, activities) {
    this._super(...arguments);
    controller.set('activities', activities);
  }
});
