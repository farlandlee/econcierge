import Ember from 'ember';
import RouteTitleMixin from 'client/mixins/route-title';

const initialTitle = window.document.title;

export default Ember.Route.extend(RouteTitleMixin, {
  model () {
    return this.store.findAll('activity');
  },

  setupController (controller, activities) {
    this._super(...arguments);
    controller.set('activities', activities);
  },

  title (tokens) {
    tokens.push(initialTitle);
    return tokens.join(' | ');
  }
});
