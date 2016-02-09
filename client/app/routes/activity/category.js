import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    return this.store.queryRecord('category', {
      slug: params.category_slug,
      activity_id: this.modelFor('activity').id
    });
  }
});
