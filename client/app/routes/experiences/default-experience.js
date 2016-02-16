import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel () {
    let {experiences} = this.modelFor('experiences');
    //@TODO transition to the default experience
    let defaultExperience = experiences.objectAt(0);
    this.replaceWith('experiences.experience', defaultExperience);
  }
});
