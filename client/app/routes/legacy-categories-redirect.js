import Ember from 'ember';

export default Ember.Route.extend({
  model ({activity_slug}) {
    this.transitionTo('activity', activity_slug);
  }
});
