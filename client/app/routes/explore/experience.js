import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';
import ResetScrollMixin from 'client/mixins/reset-scroll';
import RouteTitleMixin from 'client/mixins/route-title';
import RouteDescriptionMixin from 'client/mixins/route-meta-description';

export default Ember.Route.extend(NotFoundMixin, ResetScrollMixin, RouteTitleMixin, RouteDescriptionMixin, {
  titleToken (experience) {
    return experience.get('name');
  },

  description (experience) {
    return experience.get('description');
  },

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
