import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    return this.store.queryRecord('experience', {
      slug: params.experience_slug
    }).then(experience => {
      //@TODO get products for experience
      return {
        experience: experience,
        experiences: this.modelFor('experiences').experiences
      };
    });
  },

  afterModel () {
    this.transitionTo('experiences.experience.products');
  },

  serialize (model) {
    return {experience_slug: model ? model.get('slug') : ''};
  },

  setupController (controller, model) {
    controller.setProperties(model);
  }
});
