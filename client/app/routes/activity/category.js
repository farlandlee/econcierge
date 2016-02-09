import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    let activity_id = this.modelFor('activity').id;
    return this.store.query('category', {activity_id}).then(categories => {
      return categories.findBy('slug', params.category_slug);
    });
  }
});
