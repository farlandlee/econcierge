import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel () {
    let experiences = this.modelFor('activity.category.experience');
    return this.transitionTo('activity.category.experience.product', experiences.objectAt(0));
  }
});
