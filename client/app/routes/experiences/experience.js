import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found-mixin';

export default Ember.Route.extend(NotFoundMixin, {
  model (params) {
    let {experiences} = this.modelFor('experiences');
    let experience = experiences.findBy('slug', params.experience_slug);
    if (!experience) {
      return this.throwNotFound();
    }
    return experience;
  },

  serialize (experience) {
    return {experience_slug: experience.get('slug')};
  },

  setupController (controller, experience) {
    this._super(...arguments);
    let {experiences, category} = this.modelFor('experiences');
    controller.setProperties({
      experience: experience,
      experiences: experiences,
      activeCategoryName: category.get('name')
    });

    var nextIndex = experiences.indexOf(experience) + 1;
    nextIndex = nextIndex > experiences.get('length') - 1 ? 0 : nextIndex;

    controller.set('nextExperience', experiences.objectAt(nextIndex));
  }
});
