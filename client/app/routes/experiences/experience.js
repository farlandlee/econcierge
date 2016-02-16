import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    let {experiences} = this.modelFor('experiences');
    let experience = experiences.findBy('slug', params.experience_slug);
    if (experience) {
      return experience;
    }
    throw `No experience found for ${params.experience_slug}`;
  },

  serialize (model) {
    return {experience_slug: model ? model.get('slug') : ''};
  },

  setupController (controller, model) {
    this._super(...arguments);
    let {experiences, category} = this.modelFor('experiences');
    controller.setProperties({
      experience: model,
      experiences: experiences,
      activeCategoryName: category.get('name')
    });
  }
});
