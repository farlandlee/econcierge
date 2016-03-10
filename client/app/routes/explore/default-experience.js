import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found';

export default Ember.Route.extend(NotFoundMixin, {
  beforeModel () {
    let {category, experiences} = this.modelFor('explore');
    let defaultExperience = category.get('defaultExperience');
    defaultExperience = defaultExperience.get('isLoaded') ?
      defaultExperience : experiences.objectAt(0);

    if (defaultExperience) {
      return this.replaceWith('explore.experience', defaultExperience);
    }
    return this.throwNotFound();
  }
});
