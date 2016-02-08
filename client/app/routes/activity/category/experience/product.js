import Ember from 'ember';

export default Ember.Route.extend({
  serialize (model) {
    return {experience_slug: model.get('slug')};
  }
});
