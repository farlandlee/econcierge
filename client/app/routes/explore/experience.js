import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, {
  model (params) {
    let {experiences} = this.modelFor('explore');
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
    let {experiences, category} = this.modelFor('explore');

    controller.setProperties({
      experience: experience,
      experiences: experiences,
      activeCategoryName: category.get('name')
    });
  }
});
