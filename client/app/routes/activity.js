import Ember from 'ember';

export default Ember.Route.extend({
  model (params) {
    let slug = params.activity_slug;
    return this.store.findAll('activity').then(activities => {
      return activities.findBy('slug', slug);
    });
  }
});
