import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel () {
    let experiences = this.modelFor('experiences').experiences;
    if (experiences.get('length')) {
      return this.transitionTo('experiences.experience', experiences.objectAt(0));
    }
  }
});
