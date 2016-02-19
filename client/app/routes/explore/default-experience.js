import Ember from 'ember';
import NotFoundMixin from 'client/mixins/not-found-mixin';

export default Ember.Route.extend(NotFoundMixin, {
  beforeModel () {
    let {experiences} = this.modelFor('explore');
    //@TODO update when there's an actual "default" rather than just "first"
    let defaultExperience = experiences.objectAt(0);
    if (!defaultExperience) {
      this.throwNotFound();
    }
    this.replaceWith('explore.experience', defaultExperience);
  }
});
