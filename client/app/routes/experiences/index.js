import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel () {
    let experiences = this.modelFor('experiences').experiences;
    let experience;
    if (experiences.get('length')) {
      experience = experiences.objectAt(0);
      return this.transitionTo('experiences.experience', experience);
    }
  }
});
