import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel () {
    // Redirect to a null category
    this.transitionTo('activity.explore', '');
  }
});
